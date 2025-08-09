class GenerateMoviesJob < ApplicationJob
  def perform(movie_night)
    Rails.logger.tagged("Workflow Progress").info "Generating movies"
    movie_night.generate_movies!
  end
end
