class Api::V0::AtmsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  
  def index
    get_market_coordinates
    atms = AtmFacade.nearby_atms(@lat, @lon)
    render json: AtmSerializer.format_atms(atms), status: :ok
  end

  private

  def get_market_coordinates
    @market = Market.find(params[:market_id])
    @lat = @market.lat
    @lon = @market.lon
  end

  def not_found_error(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found #404
  end
end