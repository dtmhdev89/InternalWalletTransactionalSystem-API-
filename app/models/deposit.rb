class Deposit < Transaction
  validate :wallet_transaction_source
  validate :wallet_transaction_debit_amount

  delegate :original_source, :credit_amount, :debit_amount, to: :wallet_transaction

  def positive_balance?
    balance = original_source.balance
    !balance.negative? && (balance + (credit_amount - debit_amount)).positive?
  end

  private

  def wallet_transaction_source
    return unless wallet_transaction

    if wallet_transaction.debit_source_id != wallet_transaction.credit_source_id
      errors.add :base, message: "Debit Wallet and Credit Wallet must be from same Wallet"
    end
  end

  def wallet_transaction_debit_amount
    return unless wallet_transaction

    if wallet_transaction.debit_amount.positive?
      errors.add :base, message: "Debit amount must be zero in Deposit Transaction Type"
    end
  end
end
