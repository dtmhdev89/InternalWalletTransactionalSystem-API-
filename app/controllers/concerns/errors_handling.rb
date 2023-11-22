module ErrorsHandling
  extend ApiErrors
  extend ActiveSupport::Concern

  ERROR_CODES = {
    record_not_found: 40401,
    record_invalid: 42201,
    unauthorized: 40101
  }.freeze

  HTTP_STATUS_CODES = {
    record_not_found: 404,
    record_invalid: 422,
    unauthorized: 401
  }.freeze



  included do
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ApiErrors::Unauthorized, with: :not_authorized
  end

  private

  def error_formater(status, error_code, error_obj, force_flat_msg: false)
    {
      status: status,
      code: ERROR_CODES[error_code],
      details: details_message(error_obj, force_flat_msg: force_flat_msg)
    }
  end

  def details_message(error_obj, force_flat_msg: false)
    if force_flat_msg || error_obj.try(:record).blank?
      error_obj.message
    else
      error_obj.record.errors.full_messages
    end
  end

  def http_status(type)
    HTTP_STATUS_CODES.fetch(type){ 500 }
  end

  def record_invalid(e)
    render json: error_formater("Invalid Record", :record_invalid, e), status: http_status(:record_invalid)
  end

  def record_not_found(e)
    render json: error_formater("Not Found", :record_not_found, e), status: http_status(:record_not_found)
  end

  def not_authorized(e)
    render json: error_formater("Unauthorized", :unauthorized, e), status: http_status(:unauthorized)
  end
end
