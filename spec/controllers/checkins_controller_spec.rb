require 'rails_helper'
require 'helpers/checkin_creation_helper'

RSpec.configure do |config|
  config.include CheckinCreationHelper
end

describe CheckinsController, type: :controller do
  context 'index action: responds with JSON data based on params' do
    before(:each) { create_a_checkin(Date.tomorrow) }

    it 'lists all checkins if accessed without any params' do
      response = get(:index, params: {})

      expect(JSON.parse(response.body)['data'].first['hotel_name']).to eq('Hotel in Berlin')
    end

    context 'with valid params' do
      it 'lists all checkins if accessed with valid arrival date' do
        response = get(:index, params: {arrival_date: Date.tomorrow})

        expect(JSON.parse(response.body)['data'].first['hotel_name']).to eq('Hotel in Berlin')
      end

      it 'lists all checkins if accesses with city name' do
        response = get(:index, params: {city_name: 'Berlin'})

        expect(JSON.parse(response.body)['data'].first['hotel_name']).to eq('Hotel in Berlin')
      end
    end

    context 'with invalid params' do
      it 'doesn\'t list checkins if accessed with invalid arrival date' do
        response = get(:index, params: {arrival_date: 'XX-YY-ZZZ'})

        expect(JSON.parse(response.body)['message']).to include('invalid')
      end

      it 'doesn\'t list checkins if accesses with invalid city name' do
        response = get(:index, params: {city_name: 'Hamburg'})

        expect(JSON.parse(response.body)['data']).to be_truthy
      end
    end
  end

  context 'create action: creates checkin & validates in-coming checkins' do
    before(:all) do
      factory_girl_hotel_build = FactoryGirl.build(:hotel)
      @hotel_params = { name: factory_girl_hotel_build.name,
                        place_id: factory_girl_hotel_build.place_id,
                        rating: factory_girl_hotel_build.hotel_attributes[:rating],
                        types: factory_girl_hotel_build.hotel_attributes[:types],
                        vicinity: factory_girl_hotel_build.vicinity
      }
    end

    it 'create checkins for the selected date' do
      do_sign_in

      response = post(:create, params: { checkin_date: Date.tomorrow, hotel: @hotel_params })

      expect(JSON.parse(response.body)['message']).to include('Checkin created')
    end

    it 'doesn\'t allow to create checkins for the already checked-in date' do
      do_sign_in

      # Creating a checking for date
      post(:create, params: { checkin_date: Date.tomorrow, hotel: @hotel_params })

      # Then againg, creating a checking for the same date
      response = post(:create, params: { checkin_date: Date.tomorrow, hotel: @hotel_params })

      expect(JSON.parse(response.body)['message']).to include('You have already made a checkin')
    end
  end
end
