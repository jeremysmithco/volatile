class FetchRecommendationsJob < ApplicationJob
  def perform(movie_night, source)
    Rails.logger.tagged("Workflow Progress").info "Fetching recommendations for #{source}"
    Recommendation.fetch_for!(movie_night, source)
  end
end
