class ActiveOperator::Operation < ApplicationRecord
  belongs_to :record, polymorphic: true

  def perform
    save! unless persisted?

    request!
    process!
  rescue
    errored!
    raise
  end

  def perform_later
    save! unless persisted?

    ActiveOperator::PerformOperationJob.perform_later(self)
  end

  def request!
    return false if received?

    update!(response: request, received_at: Time.current)
  end

  def process!
    return false if !received?
    return false if processed?

    ActiveRecord::Base.transaction do
      process
      update!(processed_at: Time.current)
    end
  end

  def errored!
    return false unless persisted?

    update!(errored_at: Time.current)
  end

  def received?  = received_at?
  def processed? = processed_at?
  def errored?   = errored_at?

  def request
    raise NotImplementedError, "Operations must implement the `request` method"
  end

  def process
    raise NotImplementedError, "Operations must implement the `process` method"
  end
end
