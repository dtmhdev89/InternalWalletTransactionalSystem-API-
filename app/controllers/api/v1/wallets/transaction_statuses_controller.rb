class Api::V1::Wallets::TransactionStatusesController < ApplicationController
  def show
    render json: json_response, status: 200
  end

  private

  def json_response
    {
      job_id: job_id,
      job_status: job_data[:status],
      transaction_id: transaction.id,
      transaction_status: transaction.status.to_s,
      transaction_error_message: transaction_error_message
    }
  end

  def transaction
    @transaction ||= begin
      user_transaction = current_user.wallet_transactions
        .where(transferable: Transaction.find_by(id: job_data[:transaction_id])).first
      return user_transaction.transferable if user_transaction.present?

      raise ActiveRecord::RecordNotFound
    end
  end

  def job_id
    params[:job_id]
  end

  def job_data
    @job_data ||= Sidekiq::Status::get_all(job_id).deep_symbolize_keys
  end

  def transaction_error_message
    @transaction_error_message ||= begin
      transaction_error = transaction.wallet_transaction.latest_wallet_transaction_error
      return transaction_error.message if transaction_error.present?
    end
  end
end

