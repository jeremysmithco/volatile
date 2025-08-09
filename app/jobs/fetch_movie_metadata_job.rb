class FetchMovieMetadataJob < ApplicationJob
  def perform(movie)
    Rails.logger.tagged("Workflow Progress").info "Fetching metadata for #{movie.title}"
    movie.fetch_metadata!
  end
end
