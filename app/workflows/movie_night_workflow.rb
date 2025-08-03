class MovieNightWorkflow < SolidFlow::Base
  def build(movie_night)
    return if movie_night.completed?

    step(:fetch_recommendations, movie_night)
    step(:generate_movies, movie_night)
    step(:fetch_movie_metadata, movie_night)
    step(:filter_movies, movie_night)
    step(:complete, movie_night)
  end

  def fetch_recommendations(movie_night)
    [:google, :claude, :filmsite].map { |source| FetchRecommendationsJob.new(movie_night, source) }
  end

  def generate_movies(movie_night)
    GenerateMoviesJob.new(movie_night)
  end

  def fetch_movie_metadata(movie_night)
    movie_night.movies.map do |movie|
      FetchMovieMetadataJob.new(movie)
    end
  end

  def filter_movies(movie_night)
    FilterMoviesJob.new(movie_night)
  end

  def complete(movie_night)
    CompleteJob.new(movie_night)
  end
end
