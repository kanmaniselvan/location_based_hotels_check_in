class HotelsController < ApplicationController
  def index

  end

  def search
    hotels = Hotel.get_hotels_by_location(request.location, params[:search_key])['results']

    render json: {status: true, hotels: hotels}
  end
end
