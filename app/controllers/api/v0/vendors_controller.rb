class Api::V0::VendorsController < ApplicationController  
  def show
    vendor = Vendor.find(params[:id])
    render json: VendorSerializer.new(vendor)
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [{ detail: "Vendor with id=#{params[:id]} not found" }] }, status: :not_found
    end
  end