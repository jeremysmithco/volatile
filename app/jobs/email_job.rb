class EmailJob < ApplicationJob
  def perform(id)
    sleep 4

    Rails.logger.info "[Test Workflow] EmailJob (batch #{batch&.id}, parent batch #{batch&.parent_job_batch_id}) for id: #{id}"
  end
end
