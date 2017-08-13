require 'rails_helper'
require 'helpers/checkin_creation_helper'

RSpec.configure do |config|
  config.include CheckinCreationHelper
end

describe Checkin do
  context 'creates checkin & validates in-coming checkins' do
    before(:each) do
      factory_girl_hotel_build = FactoryGirl.build(:hotel)
      @hotel_params = { name: factory_girl_hotel_build.name,
                        place_id: factory_girl_hotel_build.place_id,
                        rating: factory_girl_hotel_build.hotel_attributes[:rating],
                        types: factory_girl_hotel_build.hotel_attributes[:types],
                        vicinity: factory_girl_hotel_build.vicinity
      }

      @user = FactoryGirl.create(:user)
      @checkin_date = Date.today.to_s
    end

    it 'create checkins for the selected date' do
      response = Checkin.create_hotel_and_do_checkin(@hotel_params, @checkin_date, @user)

      expect(response[:message]).to include('Checkin created')
    end

    it 'doesn\'t allow to create checkins for the already checked-in date' do
      Checkin.create_hotel_and_do_checkin(@hotel_params, @checkin_date, @user)

      response = Checkin.create_hotel_and_do_checkin(@hotel_params, @checkin_date, @user)

      expect(response[:message]).to include('You have already made a checkin')
    end

    it 'doesn\'t allow to create checkins for the past dates' do
      response = Checkin.create_hotel_and_do_checkin(@hotel_params, Date.yesterday.to_s, @user)

      expect(response[:message]).to include('You cannot create checkin for past dates')
    end
  end

  context 'responds to instance and class methods' do
    before(:each) do
      create_a_checkin
      @checkin = Checkin.first
    end

    it 'responds to arrival_date' do
      expect(@checkin.arrival_date).to eq(Date.today.strftime('%Y-%m-%d'))
    end

    context 'lists checkins with valid input data' do
      it 'shows all checkins if both arrival_date & city_name not given' do
        checkins = Checkin.get_all_checkins(nil, nil)
        expect(checkins).to be_truthy
      end

      it 'shows checkins made on arrival_date if arrival_date is given' do
        checkins = Checkin.get_all_checkins(Date.today.to_s, nil)
        expect(checkins).to be_truthy
      end

      it 'shows checkins created for city_name if city_name is given' do
        checkins = Checkin.get_all_checkins(nil, 'Berlin')
        expect(checkins).to be_truthy
      end
    end

    context 'lists checkins with invalid input data' do
      it 'doesn\'t show checkins made on arrival_date if arrival_date is given wrong' do
        checkins = Checkin.get_all_checkins(Date.yesterday.to_s, nil)
        expect(checkins).to be_blank
      end

      it 'doesn\'t show checkins created for city_name if city_name is given wrong' do
        checkins = Checkin.get_all_checkins(nil, 'Hamburg')
        expect(checkins).to be_blank
      end
    end
  end
end
