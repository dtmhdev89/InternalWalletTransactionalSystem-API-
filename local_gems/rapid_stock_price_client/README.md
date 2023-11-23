# RapidStockPriceClient
  Lightweight Ruby class for Rapid stock price apis

## About Rapid Stock Price API
  https://rapidapi.com/suneetk92/api/latest-stock-price

## Installation

Add this line to the application's Gemfile:

```ruby
gem "rapid_stock_price_client"
```

And then execute:

    $ bundle

Or install it by:

    $ gem install rapid_stock_price_client

## Usage
* Instantiate RapidStockPriceClient::Client.new.prices for accessing to predefined stock price endpoints
- For getting a stock price, using: get_price(indices: <indices_param>, identifier: <identifier_param>):
  ```ruby
    RapidStockPriceClient::Client.new.prices.get_price(indices: <indices_param>, identifier: <identifier_param>)
  ```
- For getting stock prices of an Index, using: get_prices(indices: <required_indices_param>, identifier: <optional_identifier_param>)
  ```ruby
    RapidStockPriceClient::Client.new.prices.get_prices(indices: <required_indices_param>, identifier: <optional_identifier_param>)
  ```
- For getting stock prices of all Indexes, using: get_price_all(identifier: <optional_identifier_param>)
  ```ruby
    RapidStockPriceClient::Client.new.prices.get_price_all(identifier: <optional_identifier_param>)
  ```

* Reponse is in JSON format

