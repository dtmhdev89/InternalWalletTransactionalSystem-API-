require "oj"

module RapidStockPriceClient
  class Response
    extend Forwardable

    def_delegators :@original_response, :code, :request, :headers

    def initialize(original_response)
      @original_response = original_response
    end

    def success?
      success_codes.include?(code)
    end

    def failure?
      !success?
    end

    def body
      @body ||= parse_json_safe(original_body)
    end

    def original_body
      @original_response.body
    end

    def object
      @object ||= initialize_object(body)
    end

    def metadata
      @metadata ||= body.fetch('responseMetadata', nil)
    end

    private

    def initialize_object(body)
      if body.is_a?(Array)
        body.map do |item|
          RapidStockPriceClient::ResponseObject.new(item)
        end
      else
        RapidStockPriceClient::ResponseObject.new(body)
      end
    end

    def success_codes
      200..226
    end

    def parse_json_safe(json)
      Oj.load(json)
    rescue Oj::ParseError
      json
    end
  end
end
