class ActiveOperator::OperateJob < ActiveStorage::BaseJob
  discard_on ActiveRecord::RecordNotFound

  def perform(operation)
    operation.operate!
  end
end
