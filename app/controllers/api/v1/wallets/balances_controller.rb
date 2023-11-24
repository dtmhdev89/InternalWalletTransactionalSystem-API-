class Api::V1::Wallets::BalancesController < ApplicationController
  def show
    render json: {balance: wallet.balance}, status: 200
  end

  private

  def wallet
    @wallet ||= current_user.wallets.enabled.find(params[:wallet_id])
  end
end
