require 'rails_helper'
require 'helpers/checkin_creation_helper'

RSpec.configure do |config|
  config.include CheckinCreationHelper
end

describe UsersController, type: :controller do
  context 'index action' do
    it 'renders JSON data with the list of user\'s checkins' do
      create_a_checkin

      response = get(:checkins, params: {id: User.first.id})

      expect(JSON.parse(response.body)['data'].first['hotel_name']).to eq('Hotel in Berlin')
    end
  end
end

