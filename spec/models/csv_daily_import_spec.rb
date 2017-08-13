require 'rails_helper'
require 'helpers/checkin_creation_helper'
require 'rake'

LocationBasedHotelsCheckIn::Application.load_tasks

RSpec.configure do |config|
  config.include CheckinCreationHelper
end

RSpec.describe 'CSV Daily Import' do
  it 'creates a CSV file and imports checkin data after successful run' do
    # Create a checkin for yesterday
    create_a_checkin(Date.yesterday)

    Rake::Task['csv:import_daily_checkins'].invoke

    date_today_strftime = Date.today.strftime('%Y-%m-%d')
    csv_location_path = File.join(Rails.root, 'tmp', 'storage', date_today_strftime)
    yesterday_date = Date.yesterday

    file = File.join(csv_location_path, "#{yesterday_date.strftime('%Y-%m-%d')}_to_#{date_today_strftime}.csv")

    expect(CSV.open(file).to_a.last.first).to eq('Test User')
  end
end
