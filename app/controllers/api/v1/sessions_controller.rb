class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: :create

  def create
    if user
      login(user)
      render json: {user_id: user.id}, status: :ok
    else
      raise ApiErrors::Unauthorized
    end
  end

  def destroy
    logout
  end

  private

  def user
    @user ||= User.authenticate_by(email: login_params[:email], password: login_params[:password])
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
