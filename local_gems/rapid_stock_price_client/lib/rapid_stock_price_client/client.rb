require "rest-client"

module RapidStockPriceClient
  class Client
    DEFAULT_API_URL = "https://latest-stock-price.p.rapidapi.com".freeze

    def initialize(api_url: "")
      @api_url = api_url.chomp('/').presence || DEFAULT_API_URL
    end

    def resource_caller
      RapidStockPriceClient::ResourceCaller.new(http_resource)
    end

    def prices
      @prices ||= RapidStockPriceClient::Resources::PriceServices::Prices.new(self)
    end

    private

    def http_resource
      RestClient::Resource.new(@api_url, headers: headers)
    end

    def headers
      {
        "X-RapidAPI-Key" => api_key,
        "X-RapidAPI-Host" => "latest-stock-price.p.rapidapi.com"
      }
    end

    def api_key
      @api_key ||= ENV.fetch("RAPID_API_KEY") {
        raise RapidStockPriceClient::Standard.new("Please prodive api key")
      }
    end
  end
end
