module RapidStockPriceClient
  module Resources
    module PriceServices
      class Prices < Base
        # Get prices of a stock company of an Index
        def get_price(indices:, identifier:)
          get(append_query_params(price_service("price"), price_params(indices: indices, identifier: identifier)))
        end

        # Get prices of stock companies of an Index
        def get_prices(indices:, identifier: nil)
          get(append_query_params(price_service("price"), price_params(indices: indices, identifier: identifier)))
        end

        # Get prices of stock companies of all Indexes
        def get_price_all(identifier: nil)
          get(append_query_params(price_service("any"), price_params(indices: nil, identifier: identifier)))
        end

        private

        def price_params(indices: nil, identifier: nil)
          params = {
            "Indices" => indices,
            "Identifier" => identifier
          }
          params.except!("Indices") if indices.nil?
          params.except!("Identifier") if identifier.nil?
          params
        end
      end
    end
  end
end
