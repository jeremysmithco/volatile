class MovieNight < ApplicationRecord
  has_many :recommendations
  has_many :movies

  def completed?
    completed_at.present?
  end

  def complete!
    touch(:completed_at)
  end

  def generate_movies!
    titles = recommendations.map(&:list).join("\n").split("\n").uniq.first(25)

    titles.each do |title|
      movies.create!(title:)
    end
  end

  def filter_movies!
    movies.where(mpaa_rating: "R").destroy_all
  end
end
