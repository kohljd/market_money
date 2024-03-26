class Api::V0::MarketsController < ApplicationController  
  def index
    render json: MarketSerializer.format_markets(Market.all)
  end
end