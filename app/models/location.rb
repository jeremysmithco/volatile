class Location < ApplicationRecord
  has_operation :geocoding

  def address
    [street, city, state, zip, country].compact_blank.join(", ")
  end
end
