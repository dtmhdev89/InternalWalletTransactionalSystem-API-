require "link_header"

module RapidStockPriceClient
  module Resources
    class Base
      extend Forwardable

      def_delegators :@resource_caller, :get, :post, :put, :delete

      def initialize(client)
        @resource_caller = client.resource_caller
      end

      private

      def append_query_params(url, params)
        return url if params.empty?

        "#{url}?#{params.to_query}"
      end

      def price_service(path)
        File.join('/', path)
      end
    end
  end
end
