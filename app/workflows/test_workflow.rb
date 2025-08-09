class TestWorkflow < SolidFlow::Base
  def build(id:)
    step(:setup, id)
    step(:send_messages, id + 2000)
    step(:cleanup, id + 1000)
  end

  def setup(id)
    SetupJob.new(id)
  end

  def send_messages(id)
    [
      EmailJob.new(id),
      SlackJob.new(id)
    ]
  end

  def cleanup(id)
    CleanupJob.new(100).set(wait: 1.minute)
  end
end
