class ActiveOperator::PerformOperationJob < ActiveStorage::BaseJob
  discard_on ActiveRecord::RecordNotFound

  def perform(operation)
    operation.perform
  end
end
