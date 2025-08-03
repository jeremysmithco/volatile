class SlackJob < ApplicationJob
  def perform(id)
    sleep 2

    Rails.logger.info "[Test Workflow] SlackJob (batch #{batch&.id}, parent batch #{batch&.parent_job_batch_id}) for id: #{id}"
  end
end
