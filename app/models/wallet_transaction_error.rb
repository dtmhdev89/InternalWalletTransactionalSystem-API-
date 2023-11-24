class WalletTransactionError < ApplicationRecord
  belongs_to :wallet_transaction

  validates :wallet_transaction_id, presence: true
  validates :error_type, :message, presence: true
end
