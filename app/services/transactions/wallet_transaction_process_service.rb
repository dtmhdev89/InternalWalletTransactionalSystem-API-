module Transactions
  class WalletTransactionProcessService
    attr_reader :wallet_transaction

    def initialize(wallet_transaction)
      @wallet_transaction = wallet_transaction
    end

    def perform
      WalletTransaction.transaction(isolation: :serializable) do
        wallet_transaction.processing!
        wallet_transaction.validate!
        wallet_transaction.lock!
        return if wallet_transaction.processed?

        wallet_transaction.processed_on = Time.now

        WalletTransactionForm.new(wallet_transaction).persist!
      end
    rescue StandardError => e
      wallet_transaction.update_columns(completed_on: Time.now, status: :failed)
      WalletTransactionError.create(wallet_transaction: wallet_transaction, error_type: e.class.to_s, message: e.message)
      wallet_transaction
    end
  end
end
