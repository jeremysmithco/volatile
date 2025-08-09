module SolidFlow
  class BuildError < StandardError; end
  class EnqueueError < StandardError; end

  class Cursor
    attr_reader :position

    def initialize(position: 0)
      @position = position
    end

    def completed?(steps)
      position >= steps.size
    end

    def next
      self.class.new(position: position.succ)
    end
  end

  class CursorSerializer < ActiveJob::Serializers::ObjectSerializer
    def serialize?(arg)
      arg.is_a?(SolidFlow::Cursor)
    end

    def serialize(cursor)
      super("position" => cursor.position)
    end

    def deserialize(hash)
      SolidFlow::Cursor.new(position: hash["position"])
    end
  end

  class Base < ActiveJob::Base
    attr_reader :cursor, :args, :kwargs, :steps

    def perform(*args, **kwargs)
      # Remove batch arg from last step passed in on_success, not needed
      args.shift if args.first.is_a?(SolidQueue::JobBatch)

      if args.first.is_a?(SolidFlow::Cursor)
        @cursor = args.shift
      else
        @cursor = Cursor.new
      end

      @args = args
      @kwargs = kwargs
      @steps = []

      build(*args, **kwargs)
      raise BuildError, "Workflow defined no steps" if steps.empty?

      return if cursor.completed?(steps)

      enqueue_step_jobs(within_batch: batch) do
        ActiveJob.perform_all_later(step_jobs)
      end
    end

    def enqueue_step_jobs(within_batch:, &)
      if within_batch
        within_batch.enqueue { SolidQueue::JobBatch.enqueue(on_success: next_job, &) }
      else
        SolidQueue::JobBatch.enqueue(on_success: next_job, &)
      end
    end

    def step_jobs
      method_name, args, kwargs = steps.at(cursor.position)
      jobs = Array(public_send(method_name, *args, **kwargs))

      raise EnqueueError, "Workflow step :#{method_name} contains no jobs to enqueue" if jobs.empty?
      raise EnqueueError, "Workflow step :#{method_name} contains objects that cannot be enqueued" unless jobs.all?(ActiveJob::Base)

      jobs
    end

    def next_job
      self.class.new(cursor.next, *args, **kwargs)
    end

    def build
      raise NotImplementedError, "Subclasses must implement build"
    end

    private

    def step(method, *args, **kwargs)
      steps << [method, args, kwargs]
    end
  end
end
