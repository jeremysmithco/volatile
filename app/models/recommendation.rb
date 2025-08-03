class Recommendation < ApplicationRecord
  belongs_to :movie_night

  def self.fetch_for!(movie_night, source)
    list = RecommendationService.new(source).fetch

    Recommendation.create!(movie_night:, source:, list:)
  end

  class RecommendationService
    def initialize(source)
      @source = source
    end

    def fetch
      sleep rand(0..5)

      rand(3..30).times.map { Faker::Movie.title }.join("\n")
    end
  end
end
