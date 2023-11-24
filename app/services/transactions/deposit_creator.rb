module Transactions
  class DepositCreator < Creator
    def perform!
      ::Deposit.new do |transaction|
        transaction.build_wallet_transaction(
          debit_source: wallet,
          debit_amount: 0,
          credit_source: wallet,
          credit_amount: transaction_params[:amount]
        )
        transaction.save!
      end
    end
  end
end
