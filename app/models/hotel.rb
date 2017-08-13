require 'net/http'
require 'uri'
class Hotel < ApplicationRecord
  has_many :checkins

  validates :name, :hotel_attributes, :place_id, :vicinity, presence: true
  validates_uniqueness_of :place_id, scope: [:name]

  ### ---- Class Methods --- ###

  def self.get_hotels_by_location(location, search_key)
    get_hotels(location, search_key)
  end

  def self.get_hotels(location, search_key)
    location_search_url_string = location_search_url(location, search_key)

    api_url = URI.escape( location_search_url_string )
    url = URI.parse( api_url )

    http = Net::HTTP.new( url.host, url.port )
    request = Net::HTTP::Get.new( url.request_uri )
    http.use_ssl = (url.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # Make the request
    response = http.request( request )

    # Parse the JSON output
    JSON.parse( response.body )
  end

  def self.location_search_url(location, search_key = 'hotels near me')
    name = search_key
    radius_in_meters = '2000'

    # Handle location, if accessed from local machine.
    if location.blank? || location.latitude.zero? || location.longitude.zero?
      # Set Berlin location
      location = '52.52000659999999,13.404954'
    else
      location = "#{location.latitude},#{location.longitude}"
    end

    key = ENV['GOOGLE_LOCATION_SEARCH_API_KEY']
    google_api_end_point_url = ENV['GOOGLE_LOCATION_SEARCH_API_URL']

    "#{google_api_end_point_url}?location=#{location}&radius=#{radius_in_meters}&name=#{name}&key=#{key}"
  end
end
