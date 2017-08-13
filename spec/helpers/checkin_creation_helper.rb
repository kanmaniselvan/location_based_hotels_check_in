module CheckinCreationHelper
  def create_a_checkin(date_of_checkin=Date.today)
    hotel = FactoryGirl.create(:hotel)
    user = FactoryGirl.create(:user)

    FactoryGirl.create(:checkin, date_of_checkin: date_of_checkin, user_id: user.id, hotel_id: hotel.id)
  end

  def do_sign_in
    user = FactoryGirl.create(:user)
    sign_in(user)
  end
end
