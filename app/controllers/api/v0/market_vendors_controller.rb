class Api::V0::MarketVendorsController < ApplicationController  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def create
    return params_missing_error if params_missing?
    
    find_market_and_vendor
    if existing_market_vendor?
      error_message = "Validation failed: Market vendor asociation already exists"
      render json: ErrorSerializer.format_error(error_message), status: :unprocessable_entity #422
    else
      @market_vendor = MarketVendor.create(market_vendor_params)
      render json: {message: "Successfully added vendor to market"}, status: :created
    end
  end

  private
  def params_missing_error
    error_message = "Validation failed: Neither Market or Vendor can be blank"
    render json: ErrorSerializer.format_error(error_message), status: :bad_request #400
  end

  def params_missing?
    (params[:market_id] && params[:vendor_id]).blank?
  end

  def existing_market_vendor?
    MarketVendor.exists?(market_id: @market.id, vendor_id: @vendor.id)
  end

  def find_market_and_vendor
    @market = Market.find(params[:market_id])
    @vendor = Vendor.find(params[:vendor_id])
  end

  def not_found_error(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found #404
  end

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end
end