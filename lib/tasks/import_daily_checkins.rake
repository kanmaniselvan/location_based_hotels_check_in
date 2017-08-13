namespace :csv do
  desc 'Import daily checkins to CSV'
  task import_daily_checkins: :environment do
    require 'csv'
    require 'fileutils'

    date_today_strftime = Date.today.strftime('%Y-%m-%d')
    csv_location_path = File.join(Rails.root, 'tmp', 'storage', date_today_strftime)
    FileUtils.mkdir_p(csv_location_path) unless File.directory?(csv_location_path)

    yesterday_date = Date.yesterday

    checkins = Checkin.where(date_of_checkin: yesterday_date).joins(:user).order('users.name').includes(:user, :hotel)

    file = File.join(csv_location_path, "#{yesterday_date.strftime('%Y-%m-%d')}_to_#{date_today_strftime}.csv")

    CSV.open(file, 'w') do |writer|
      writer << ['User Name', 'User Email', 'Arrival Date', 'Hotel Name', 'Vicinity', 'CheckIn Request at']

      checkins.each do |checkin|
        writer << [checkin.user.name,
                   checkin.user.email,
                   checkin.arrival_date,
                   checkin.hotel.name,
                   checkin.hotel.vicinity,
                   checkin.created_at]
      end
    end
  end
end
