class FilterMoviesJob < ApplicationJob
  def perform(movie_night)
    Rails.logger.tagged("Workflow Progress").info "Filtering movies"
    movie_night.filter_movies!
  end
end
