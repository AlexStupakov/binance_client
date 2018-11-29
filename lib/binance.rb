require 'rest-client'
require 'date'
require 'uri'
require 'json'
require 'dotenv/load'

module Binance
  extend self
  BASE_URL = 'https://api.binance.com'.freeze

  def account
    params = additional_params
    response = get_api_call("#{BASE_URL}/api/v3/account", params)

    build_result response
  end

  def all_my_trades(options = {})
    response = combine_account_assets_to_symbols.map do |symbol|
      my_trades(symbol, options)
    end.to_json

    build_result response
  end

  def my_trades(symbol = 'LTCBTC', options = {})
    params = {
      symbol: symbol,
      limit: options.fetch(:limit, 500),
      fromId: options.fetch(:from_id, nil)
    }.merge additional_params

    response = get_api_call "#{BASE_URL}/api/v3/myTrades", params

    build_result response
  end

  protected

  def additional_params
    {
      recvWindow: 5000,
      timestamp: Time.now.to_i * 1000
    }
  end

  def api_key
    ENV['api_key'] || raise('missing api_key in .env file')
  end

  def api_secret
    ENV['api_secret'] || raise('missing api_secret in .env file')
  end

  def build_result(response)
    p '_____________________________________________________________________________'
    puts response
    JSON.parse response
  end

  def combine_account_assets_to_symbols
    assets = account['balances'].map { |balance| balance['asset'] }
    assets.product(assets).map do |combination|
      combination.join unless combination[0] == combination[1]
    end.compact
  end

  def get_api_call(url, params)
    RestClient.get url,
                   params: params_with_signature(params, api_secret),
                   'X-MBX-APIKEY' => api_key
  rescue RestClient::ExceptionWithResponse => err
    err.response
  end

  def params_with_signature(params, secret)
    params = params.reject { |_k, v| v.nil? }
    query_string = URI.encode_www_form(params)
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, query_string)
    params.merge(signature: signature)
  end
end
