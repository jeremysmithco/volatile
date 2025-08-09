class CleanupJob < ApplicationJob
  def perform(id)
    Rails.logger.info "[Test Workflow] CleanupJob (batch #{batch&.id}, parent batch #{batch&.parent_job_batch_id}) for id: #{id}"
  end
end
