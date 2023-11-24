class Wallet < ApplicationRecord
  belongs_to :account
  has_many :debit_wallet_transactions, foreign_key: :debit_source_id, class_name: WalletTransaction.name
  has_many :credit_wallet_transactions, foreign_key: :credit_source_id, class_name: WalletTransaction.name
  has_many :wallet_transactions, foreign_key: :debit_source_id, class_name: WalletTransaction.name

  scope :enabled, -> { where(enabled: true).order(created_at: :asc) }

  def balance
    @balance ||= begin
      results = self.class.find_by_sql([
        balance_sql,
        wallet_id: id,
        succeeded_status: WalletTransaction.statuses.values_at(:succeeded).first
      ])
      results.first.balance_amount || 0
    end
  end

  private

  def balance_sql
    %q{
      SELECT wt1.*, wt2.*, (wt2.credit_amount - wt1.debit_amount) as balance_amount FROM
      (
        SELECT COALESCE(SUM(inner_wt1.debit_amount), 0) as debit_amount
        FROM wallet_transactions as inner_wt1
        WHERE inner_wt1.debit_source_id = :wallet_id AND
          inner_wt1.status = :succeeded_status
      ) as wt1
      CROSS JOIN
      (
        SELECT COALESCE(SUM(inner_wt2.credit_amount), 0) as credit_amount
        FROM wallet_transactions as inner_wt2
        WHERE inner_wt2.credit_source_id = :wallet_id AND
          inner_wt2.status = :succeeded_status
      ) as wt2
    }
  end
end
