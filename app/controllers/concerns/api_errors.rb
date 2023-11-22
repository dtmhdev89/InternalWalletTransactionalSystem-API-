module ApiErrors
  CUSTOM_ERROR_KLASSES = %w[Unauthorized]

  class BaseError < ::StandardError; end

  CUSTOM_ERROR_KLASSES.each do |error_klass|
    klass_name = "ApiErrors::#{error_klass}"
    next if self.const_defined?(klass_name)
    self.const_set(error_klass, Class.new(BaseError))
  end
end
