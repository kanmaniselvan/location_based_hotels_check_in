require 'rails_helper'
require 'helpers/checkin_creation_helper'

RSpec.configure do |config|
  config.include CheckinCreationHelper
end

describe User do
  before(:each) do
    create_a_checkin
    @user = User.first
  end

  it 'responds to checkins_info and returns value' do
    expect(@user.checkins_info.first[:hotel_name]).to eq('Hotel in Berlin')
  end

  it 'responds to my_info and returns value' do
    expect(@user.my_info[:name]).to eq('Test User')
  end
end
