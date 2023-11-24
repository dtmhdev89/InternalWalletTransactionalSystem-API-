class ApplicationController < ActionController::API
  include ActionController::Cookies

  include ErrorsHandling
  include Authentication
end
