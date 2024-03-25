class Api::V0::VendorsController < ApplicationController  
  # def show
  #    render json: Vendor.find(params[:id])
  # end
  def show
    vendor = Vendor.find(params[:id])
    render json: vendor
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [{ detail: "Vendor with id=#{params[:id]} not found" }] }, status: :not_found
  end
end
