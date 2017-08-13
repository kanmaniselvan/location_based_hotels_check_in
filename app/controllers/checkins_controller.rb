class CheckinsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    data = Checkin.get_all_checkins(params[:arrival_date], params[:city_name])

    render json: { status: true, message: 'Success', data: data }
  rescue StandardError => ex
    render json: { status: false, message: ex.message }
  end

  def create
    response = Checkin.create_hotel_and_do_checkin(checkin_params, params[:checkin_date], current_user)

    render json: response
  rescue StandardError => ex
    render json: { status: false, message: ex.message }
  end

  protected
  def checkin_params
    params.require(:hotel).permit(:place_id, :name, :rating, :types, :vicinity)
  end
end
