require 'spec_helper'
require './lib/binance'

describe 'Binance::API' do

  describe 'account' do
    it 'should return response body' do
      endpoint = "https://api.binance.com/api/v3/account"
      body = '{"makerCommission":15,"takerCommission":15,"buyerCommission":0,"sellerCommission":0,"canTrade":true,"canWithdraw":true,"canDeposit":true,"updateTime":123456789,"balances":[{"asset":"BTC","free":"4723846.89208129","locked":"0.00000000"},{"asset":"LTC","free":"4763368.68006011","locked":"0.00000000"}]}'
      stub_request(:get, /#{endpoint}.*/).
        to_return(status: 200, body: body, headers: {})

      expect(Binance::API.account).to eq JSON.parse body
    end
  end

  describe 'my_trades' do
    it 'should return response body' do
      endpoint = "https://api.binance.com/api/v3/myTrades"
      body = '[{"id":28457,"orderId":100234,"price":"4.00000100","qty":"12.00000000","commission":"10.10000000","commissionAsset":"BNB","time":1499865549590,"isBuyer":true,"isMaker":false,"isBestMatch":true}]'
      stub_request(:get, /#{endpoint}.*/).
        to_return(status: 200, body: body, headers: {})

      expect(Binance::API.my_trades).to eq JSON.parse body
    end
  end

  describe 'all_my_trades' do
    it 'should return response body for 2 simbols' do
      endpoint = "https://api.binance.com/api/v3/account"
      body = '{"makerCommission":15,"takerCommission":15,"buyerCommission":0,"sellerCommission":0,"canTrade":true,"canWithdraw":true,"canDeposit":true,"updateTime":123456789,"balances":[{"asset":"BTC","free":"4723846.89208129","locked":"0.00000000"},{"asset":"LTC","free":"4763368.68006011","locked":"0.00000000"}]}'
      stub_request(:get, /#{endpoint}.*/).
          to_return(status: 200, body: body, headers: {})

      endpoint = "https://api.binance.com/api/v3/myTrades"
      body = '[{"id":28457,"orderId":100234,"price":"4.00000100","qty":"12.00000000","commission":"10.10000000","commissionAsset":"BNB","time":1499865549590,"isBuyer":true,"isMaker":false,"isBestMatch":true}]'
      stub_request(:get, /#{endpoint}.*/).
        to_return(status: 200, body: body, headers: {})

      all_my_trades_body = JSON.parse "[#{body},#{body}]"
      expect(Binance::API.all_my_trades).to eq all_my_trades_body
    end
  end

  describe 'combine_account_assets_to_symbols' do
    it 'should combine all the account currencies' do
      endpoint = "https://api.binance.com/api/v3/account"
      body = '{"balances":[{"asset":"BTC"},{"asset":"LTC"},{"asset":"ATC"}]}'
      stub_request(:get, /#{endpoint}.*/).
          to_return(status: 200, body: body, headers: {})

      expect(Binance::API.send :combine_account_assets_to_symbols).to eq ["BTCLTC", "BTCATC", "LTCBTC", "LTCATC", "ATCBTC", "ATCLTC"]
    end
  end
end