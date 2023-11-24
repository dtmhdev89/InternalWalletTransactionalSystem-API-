class WalletTransaction < ApplicationRecord
  enum :status, {queued: 0, processing: 1, failed: 2, succeeded: 3}

  belongs_to :transferable, polymorphic: true
  belongs_to :transferable, polymorphic: true
  belongs_to :debit_source, class_name: Wallet.name
  belongs_to :original_source, foreign_key: :debit_source_id, class_name: Wallet.name
  belongs_to :credit_source, class_name: Wallet.name
  has_many :wallet_transaction_errors, dependent: :destroy
  has_one :latest_wallet_transaction_error, -> { order(created_at: :desc) }, class_name: WalletTransactionError.name

  validates :status, inclusion: {in: statuses.keys}
  validates :debit_source_id, :credit_source_id, presence: true
  validates :debit_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :credit_amount, numericality: { greater_than_or_equal_to: 0 }

  scope :pending_transactions, -> do
    where(completed_on: nil, processed_on: nil, status: :queued)
      .order(created_at: :asc)
  end

  class << self
    def execute_pending_transactions(pending_transactions: nil, timeout: 300)
      pending_transactions ||= self.pending_transactions
      start = Time.now

      pending_transactions.each do |transaction|
        return false if timeout && Time.now - start > timeout
        Transactions::WalletTransactionProcessService.new(transaction).perform
      end
    end
  end

  def positive_balance?
    transferable.positive_balance?
  end

  def processed?
    (processed_on && processing?) || failed? || succeeded?
  end
end
