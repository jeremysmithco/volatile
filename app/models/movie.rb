class Movie < ApplicationRecord
  belongs_to :movie_night

  def fetch_metadata!
    metadata = MetadataService.new(title).fetch

    update!(
      mpaa_rating: metadata[:mpaa],
      runtime_minutes: metadata[:runtime],
      description: metadata[:description],
      release_year: metadata[:released],
    )
  end

  class MetadataService
    def initialize(title)
      @title = title
    end

    def fetch
      sleep rand(0..5)

      {
        mpaa: ["G", "PG", "PG-13", "R"].sample,
        runtime: rand(90..160),
        description: Faker::Lorem.paragraph(sentence_count: 10),
        released: rand(1950..2025)
      }
    end
  end
end
