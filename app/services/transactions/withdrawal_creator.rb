module Transactions
  class WithdrawalCreator < Creator
    def perform!
      ::Withdrawal.new do |transaction|
        transaction.build_wallet_transaction(
          debit_source: wallet,
          debit_amount: transaction_params[:amount],
          credit_source: wallet,
          credit_amount: 0
        )
        transaction.save!
      end
    end
  end
end
