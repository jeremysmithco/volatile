class Location < ApplicationRecord
  has_operation :geocoding

  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :country, presence: true

  def address
    [street, city, state, zip, country].compact_blank.join(", ")
  end
end
