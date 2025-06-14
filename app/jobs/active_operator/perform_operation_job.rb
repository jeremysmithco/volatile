class ActiveOperator::PerformOperationJob < ActiveJob::Base
  discard_on ActiveRecord::RecordNotFound

  def perform(operation)
    operation.perform
  end
end
