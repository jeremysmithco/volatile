class ChildWorkflow < SolidFlow::Base
  def build(id:)
    step(:setup, id)
    step(:send_messages, id, additional: 40)
    step(:send_another, multiplier: 2)
    step(:cleanup)
  end

  def setup(id)
    SetupJob.new(id)
  end

  def send_messages(id, additional: 10)
    [
      EmailJob.new(id + additional),
      SlackJob.new(id + additional)
    ]
  end

  def send_another(multiplier: 1)
    SlackJob.new(100 * multiplier)
  end

  def cleanup
    CleanupJob.new(100)
  end
end
