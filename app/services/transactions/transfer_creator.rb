module Transactions
  class TransferCreator < Creator
    def perform!
      ::Transfer.new do |transaction|
        transaction.build_wallet_transaction(
          debit_source: wallet,
          debit_amount: transaction_params[:amount],
          credit_source: credit_source,
          credit_amount: transaction_params[:amount]
        )
        transaction.save!
      end
    end

    private

    def credit_source
      ::Wallet.find(transaction_params[:target_wallet_id])
    end
  end
end
