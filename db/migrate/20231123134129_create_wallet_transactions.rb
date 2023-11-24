class CreateWalletTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_transactions, id: :uuid do |t|
      t.references :debit_source, type: :uuid, null: false, foreign_key: { to_table: :wallets }
      t.references :credit_source, type: :uuid, null: false, foreign_key: { to_table: :wallets }
      t.decimal :debit_amount, null: false, default: 0, precision: 25, scale: 5
      t.decimal :credit_amount, null:false, default: 0, precision: 25, scale: 5
      t.integer :status, null: false, default: 0
      t.references :transferable, polymorphic: true, type: :uuid
      t.datetime :processed_on
      t.datetime :completed_on

      t.timestamps
    end
  end
end
