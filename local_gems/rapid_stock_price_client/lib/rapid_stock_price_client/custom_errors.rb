require 'oj'

module RapidStockPriceClient
  class CustomErrors < StandardError
    attr_reader :original_error, :http_response, :error_message

    def initialize(original_error)
      @original_error = original_error
      @http_response = @original_error.response if @original_error.respond_to?(:response)
      @error_message = parsed_response if @http_response
      super(@original_error.to_s)
    end

    private

    def parsed_response
      @json_error_parser ||= parse_json_body
    end

    def parse_json_body
      Oj.load(@http_response.body)
    rescue
      ''
    end
  end

  class ConnectionError < CustomErrors; end
  class StandardError < CustomErrors; end
  class BadResponse < CustomErrors; end
  class UnauthorisedError < CustomErrors; end
end
