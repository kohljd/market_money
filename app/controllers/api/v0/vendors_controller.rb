class Api::V0::VendorsController < ApplicationController  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_error

  def index
    find_market_and_vendors
    render json: VendorSerializer.new(@vendors)
  end

  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
  end

  def create
    # require 'pry'; binding.pry
    # begin
      new_vendor = Vendor.create!(vendor_params)
      render json: VendorSerializer.new(new_vendor), status: :created
    # rescue ActiveRecord::RecordInvalid => invalid
    #   render json: ErrorSerializer.format_error(invalid), status: :bad_request
    # end
  end



  private
  def find_market_and_vendors
    @market = Market.find(params[:market_id])
    @vendors = @market.vendors
  end

  def not_found_error(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found
  end

  def invalid_error(exception)
    render json: ErrorSerializer.format_error(exception), status: :bad_request
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted )
  end
end