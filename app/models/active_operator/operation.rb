class ActiveOperator::Operation < ApplicationRecord
  belongs_to :record, polymorphic: true

  def operator
    operator_class.new(self)
  end

  delegate :request, :process, to: :operator

  def operate!
    request!
    process!
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

  def fail!
    update!(failed_at: Time.current)
  end

  def received?  = received_at?
  def processed? = processed_at?
  def failed?    = failed_at?

  private

  def operator_class
    "#{name.to_s.camelize}#{"V#{version}"}".constantize
  end
end
