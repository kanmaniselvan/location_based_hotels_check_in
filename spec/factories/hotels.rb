FactoryGirl.define do
  factory :hotel do
    name 'Hotel in Berlin'
    hotel_attributes {{ rating: 4, types: 'lodging,point_of_interest,establishment' }}
    place_id 'qweert124'
    vicinity 'Berlin'
  end
end
