require "hashie/mash"

module RapidStockPriceClient
  class ResponseObject < SimpleDelegator
    def initialize(attributes)
      __setobj__(Hashie::Mash.new(sanitize_attributes(attributes)))
    end

    private

    def sanitize_attributes(attributes)
      {}.tap do |hash|
        attributes.each do |key, value|
          hash[key.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase] = value
        end
      end
    end
  end
end
