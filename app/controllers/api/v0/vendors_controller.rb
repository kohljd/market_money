class Api::V0::VendorsController < ApplicationController  
  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [{ detail: "Vendor with id=#{params[:id]} not found" }] }, status: :not_found
  end

  def create
    # require 'pry'; binding.pry
    new_vendor = Vendor.create(vendor_params)
    render json: VendorSerializer.new(new_vendor)
  end



  private

    def vendor_params
      params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted )
    end
end