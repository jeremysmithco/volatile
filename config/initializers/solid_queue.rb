# frozen_string_literal: true

module SolidQueue
  class Dispatcher
    private

    def poll
      dispatch_next_batch

      0.seconds
    end
  end
end
