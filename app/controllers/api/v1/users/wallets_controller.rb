class Api::V1::Users::WalletsController < ApplicationController
  def index
    render json: {wallet_ids: user.wallets.enabled.pluck(:id)}, status: 200
  end

  private

  def user
    @user ||= begin
      return current_user if current_user.id == params[:user_id].to_i

      raise ApiErrors::Unauthorized, "User Unauthorized"
    end
  end
end
