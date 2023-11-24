class Transaction < ApplicationRecord
  has_one :wallet_transaction, as: :transferable

  validates :type, presence: true
  validates :wallet_transaction, presence: true

  delegate :status, to: :wallet_transaction
end
