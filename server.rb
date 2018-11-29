require 'sinatra'
require 'sinatra/namespace'
require './lib/binance'

get '/' do
  <<-eos
   Welcome to Binance client!
   <br>available endpoints:
   <br>/api/v1/account
   <br>/api/v1/my_trades?symbol=LTCBTC
   <br>/api/v1/all_my_trades
  eos
end

namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  get '/account' do
    Binance::API.account
  end
  get '/my_trades' do
    Binance::API.my_trades(params[:symbol], limit: params[:limit], from_id: params[:from_id])
  end
  get '/all_my_trades' do
    Binance::API.all_my_trades
  end
end
