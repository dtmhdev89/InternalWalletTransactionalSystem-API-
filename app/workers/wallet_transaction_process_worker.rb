class WalletTransactionProcessWorker
  include Sidekiq::Job
  include Sidekiq::Status::Worker

  sidekiq_options queue: "high", retry_queue: false

  def perform(params)
    params = params.deep_symbolize_keys
    wallet_transaction = Transaction.find(params[:transaction_id]).wallet_transaction
    store transaction_id: params[:transaction_id]
    Transactions::WalletTransactionProcessService.new(wallet_transaction).perform
  end
end
