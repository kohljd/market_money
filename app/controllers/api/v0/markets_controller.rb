class Api::V0::MarketsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    find_market
    render json: MarketSerializer.new(@market)
  end

  def search
    if valid_params?
      markets = Market.filter_markets(params[:state], params[:city], params[:name])
      render json: MarketSerializer.new(markets), status: :ok
    else
      error = "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
      render json: ErrorSerializer.format_error(error), status: :unprocessable_entity
    end
  end

  private
  
  def find_market
    @market = Market.find(params[:id])
  end

  def not_found_error(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found
  end

  def valid_params?
    if params.key?(:city) && ((!params.key?(:name)) && (!params.key?(:state)))
      return false
    elsif !params.key?(:state) && ((params.key?(:name)) && (params.key?(:city)))
      return false
    end
    true
  end
 
end