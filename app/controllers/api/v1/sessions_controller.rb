class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def create
    if user
      login(user)
      render json: {user_id: user.id}, status: :ok
    else
      render status: :unauthorized
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
