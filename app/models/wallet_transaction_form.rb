class WalletTransactionForm
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion

  attr_reader :wallet_transaction

  validate :debit_source_positive_balance, if: :deposit_or_withdrawal_transaction?
  validate :debit_source_transfer_balance, if: :transfer_transaction?
  validate :credit_source_transfer_balance, if: :transfer_transaction?

  delegate :transferable, to: :wallet_transaction


  def initialize(wallet_transaction)
    @wallet_transaction = wallet_transaction
  end

  def persist!
    validate!
    wallet_transaction.status = :succeeded
    wallet_transaction.save
    wallet_transaction.update_column(:completed_on, Time.now)
  end

  private

  def deposit_or_withdrawal_transaction?
    transferable.is_a?(Deposit) || transferable.is_a?(Withdrawal)
  end

  def transfer_transaction?
    transferable.is_a?(Transfer)
  end

  def debit_source_positive_balance
    return unless wallet_transaction

    unless wallet_transaction.positive_balance?
      errors.add :base, insufficient_balance_message[:positive_balance]
    end
  end

  def debit_source_transfer_balance
    return unless wallet_transaction

    unless transferable.source_wallet_positive_balance?
      errors.add :base, insufficient_balance_message[:transfer_debit_balance]
    end
  end

  def credit_source_transfer_balance
    return unless wallet_transaction

    unless transferable.target_wallet_positive_balance?
      errors.add :base, insufficient_balance_message[:transfer_credit_balance]
    end
  end

  def insufficient_balance_message
    {
      positive_balance: "Insufficient balance on the wallet to execute transaction",
      transfer_debit_balance: "Insufficient balance on the source wallet to execute transaction",
      transfer_credit_balance: "Negative amount on the target wallet to execute transaction"
    }
  end
end
