class UsersController < ApplicationController
  skip_before_action :authenticate_user!

  def checkins
    user = User.where(id: params[:id]).first
    if user.blank?
      render json: { status: false, message: 'Invalid User ID' } and return
    end

    render json: { status: true, message: 'Success', data: user.checkins_info, user: user.my_info }
  end
end
