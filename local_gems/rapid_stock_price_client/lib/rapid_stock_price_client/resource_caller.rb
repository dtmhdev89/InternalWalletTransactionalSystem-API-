require "oj"

module RapidStockPriceClient
  class ResourceCaller
    def initialize(resource)
      @resource = resource
    end

    def get(path)
      wrap_exception { @resource[path].get }
    end

    def post(path, payload, use_form_data = false)
      send_payload(:post, path, payload, use_form_data)
    end

    def put(path, payload)
      send_payload(:put, path, payload)
    end

    def delete(path)
      wrap_exception { @resource[path].delete }
    end

    private

    def send_payload(method, path, payload, use_form_data = false)
      payload = hash_to_json(payload) unless use_form_data
      wrap_exception { @resource[path].send(method, payload, headers(use_form_data)) }
    end

    def hash_to_json(hash)
      Oj.dump(hash, mode: :compat)
    end

    def headers(use_form_data)
      use_form_data ? form_data_header : json_header
    end

    def form_data_header
      {
         "Content-Type": "application/x-www-form-urlencoded",
         "Accept": "application/json"
      }
    end

    def json_header
      {
        "Content-Type": "application/json",
        "Accept": "application/json"
      }
    end

    def wrap_exception
      RapidStockPriceClient::Response.new(yield)
    rescue RestClient::ExceptionWithResponse => e
      case e.http_code
      when 400, 412 # 412 for validation errors (precondition failed), 400 for bad auth
        RapidStockPriceClient::Response.new(e.response)
      when 401 # Unauthorised - maybe the token expired?
        raise RapidStockPriceClient::UnauthorisedError.new(e)
      else
        raise RapidStockPriceClient::BadResponse.new(e)
      end
    rescue RestClient::Exception, SocketError => e
      raise RapidStockPriceClient::ConnectionError.new(e)
    rescue => e
      raise RapidStockPriceClient::StandardError.new(e)
    end
  end
end
