class Transfer < Transaction
  delegate :debit_source, :credit_source, :debit_amount, :credit_amount, to: :wallet_transaction

  def source_wallet_positive_balance?
    return true unless wallet_transaction

    debit_source_balance = debit_source.balance
    debit_source_balance.positive? && !(debit_source_balance - debit_amount).negative?
  end

  def target_wallet_positive_balance?
    return true unless wallet_transaction

    !credit_source.balance.negative?
  end
end
