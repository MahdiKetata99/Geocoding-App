class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Geocoding configuration
  geocoded_by :full_address do |obj, results|
    if geo == results.first
      obj.latitude = geo.latitude
      obj.longitude = geo.longitude

      # Get address components from Nominatim
      address = geo.data["address"]
      obj.federal_state = address["state"]
      obj.country = address["country"]
      obj.postal_code = address["postcode"]
      obj.district = address["city_district"] || address["county"] || address["suburb"]
      obj.formatted_address = geo.data["display_name"]
    end
  end

  after_validation :geocode, if: ->(obj) {
    !Rails.env.test? && (obj.street_changed? || obj.city_changed? || obj.zip_changed?)
  }

  # Validations for address fields
  validates :street, :city, :zip, presence: true

  validates :latitude, numericality: {
    greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90,
    message: "must be between -90 and 90"
  }, allow_nil: true

  validates :longitude, numericality: {
    greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180,
    message: "must be between -180 and 180"
  }, allow_nil: true

  private

  def full_address
    [ street, city, zip, "Germany" ].compact.join(", ")
  end
end
