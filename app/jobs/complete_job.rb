class CompleteJob < ApplicationJob
  def perform(movie_night)
    Rails.logger.tagged("Workflow Progress").info "Completing movie night"
    movie_night.complete!
  end
end
