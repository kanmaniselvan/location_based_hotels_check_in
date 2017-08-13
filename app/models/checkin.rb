class Checkin < ApplicationRecord
  belongs_to :user
  belongs_to :hotel

  validates :user_id, :hotel_id, :date_of_checkin, presence: true
  validates_uniqueness_of :date_of_checkin, scope: [:user_id]

  def created_at
    super.strftime('%Y-%m-%d')
  end

  def date_of_checkin
    super.strftime('%Y-%m-%d')
  end

  def arrival_date
    self.date_of_checkin
  end

  def self.get_scope_checkins(scope)
    scope.map do |checkin|
      hotel = checkin.hotel
      { hotel_name: hotel.name,
        checkin_request_date: checkin.created_at,
        vicinity: hotel.vicinity,
        arrival_date: checkin.arrival_date }
    end
  end

  def self.get_all_checkins(arrival_date, city_name)
    if arrival_date.blank? && city_name.blank?
      scope = Checkin.all.includes(:hotel)
    end

    if arrival_date.present?
      scope = Checkin.where(date_of_checkin: Date.parse(arrival_date)).includes(:hotel)
    end

    if city_name.present?
      scope = Checkin.joins(:hotel).where('hotels.vicinity like ?', "%#{city_name}%")
    end

    get_scope_checkins(scope)
  end

  def self.create_hotel_and_do_checkin(hotel_params, checkin_date, user)
    # Create Hotel or update the hotel
    hotel = Hotel.where(place_id: hotel_params[:place_id]).first_or_initialize
    hotel.name = hotel_params[:name]
    hotel.hotel_attributes = hotel_params.select{ |attr, value| %w(name vicinity place_id).exclude?(attr.to_s) }
    hotel.vicinity = hotel_params[:vicinity]
    hotel.save!

    # Check for existing checkin for the user
    date_of_checkin = Date.parse(checkin_date) rescue Date.today

    if date_of_checkin < Date.today
      return { status: false, message: 'You cannot create checkin for past dates!' }
    end

    checkin = Checkin.where(user: user, date_of_checkin: date_of_checkin).first

    if checkin.present?
      status = false
      message = "You have already made a checkin for '#{checkin.hotel.name}' on '#{checkin.date_of_checkin}'"
    else
      # If not found create a new checking
      checkin = hotel.checkins.create!(user: user, date_of_checkin: date_of_checkin)
      status = true
      message = "Checkin created for '#{checkin.hotel.name}' on '#{checkin.date_of_checkin}'"
    end

    { status: status, message: message }
  end
end
