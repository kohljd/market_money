class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    find_market
    render json: MarketSerializer.new(@market)
  end

  private
  
  def find_market
    @market = Market.find(params[:id])
  end

  def not_found_error(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found
  end
end