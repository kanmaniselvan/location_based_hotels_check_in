FactoryGirl.define do
  factory :checkin do
    user_id 1
    hotel_id 1
    date_of_checkin Date.today
  end
end
