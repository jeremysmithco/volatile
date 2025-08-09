class MetadataBackfillWorkflow < SolidFlow::Base
  def build(movie_night)
    Movie.where(movie_night: movie_night).find_in_batches(batch_size: 5) do |batch|
      step(:fetch_movie_metadata, movie_night, batch.first.id, batch.last.id)
    end
  end

  def fetch_movie_metadata(movie_night, start_id, end_id)
    Movie.where(movie_night: movie_night).where(id: start_id..end_id).map do |movie|
      FetchMovieMetadataJob.new(movie)
    end
  end
end
