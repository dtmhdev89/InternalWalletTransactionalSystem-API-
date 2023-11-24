class Api::V1::Wallets::TransfersController < ApplicationController
  before_action :transaction, only: %i[create]

  def create
    job_id = WalletTransactionProcessWorker.perform_async({transaction_id: transaction.id}.stringify_keys)
    render json: json_response(job_id), status: 200
  end

  private

  def transaction
    @transaction ||= Transactions::TransferCreator.new(wallet, transaction_params).perform!
  end

  def wallet
    @wallet ||= current_user.wallets.enabled.find(params[:wallet_id])
  end

  def transaction_params
    {
      target_wallet_id: params[:target_wallet_id],
      amount: params[:amount]
    }
  end

  def json_response(job_id)
    {
      job_id: job_id,
      job_status: Sidekiq::Status::status(job_id),
      transaction_id: transaction.id,
      transaction_status: transaction.status.to_s
    }
  end
end
