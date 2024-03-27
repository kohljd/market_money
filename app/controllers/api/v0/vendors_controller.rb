class Api::V0::VendorsController < ApplicationController  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error

  def index
    find_market_and_vendors
    render json: VendorSerializer.new(@vendors)
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  private
  def find_market_and_vendors
    @market = Market.find(params[:market_id])
    @vendors = @market.vendors
  end

  def not_found_error(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found
  end
end