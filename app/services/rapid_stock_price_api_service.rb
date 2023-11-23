class RapidStockPriceApiService
  def self.get_price(indices:, identifier:)
    RapidStockPriceClient::Client.new.prices.get_price(indices: indices, identifier: identifier)
  end

  def self.get_prices(indices:, identifier: nil)
    RapidStockPriceClient::Client.new.prices.get_prices(indices: indices, identifier: identifier)
  end

  def self.get_price_all(identifier: nil)
    RapidStockPriceClient::Client.new.prices.get_price_all(identifier: identifier)
  end
end
