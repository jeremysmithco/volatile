class ParentWorkflow < SolidFlow::Base
  def build(id)
    step(:setup, id)
    step(:send_messages, id)
    step(:cleanup)
  end

  def setup(id)
    SetupJob.new(id)
  end

  def send_messages(id)
    child_workflow(id)
      .concat(send_emails(id))
      .concat(send_slacks(id))
  end

  def cleanup
    CleanupJob.new(100)
  end

  private

  def send_emails(id)
    (0..2).map { |i| EmailJob.new(id + i) }
  end

  def send_slacks(id)
    (0..4).map { |i| SlackJob.new(id + i) }
  end

  def child_workflow(id)
    [ChildWorkflow.new(id: id)]
  end
end
