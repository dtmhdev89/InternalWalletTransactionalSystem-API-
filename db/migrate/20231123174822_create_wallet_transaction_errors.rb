class CreateWalletTransactionErrors < ActiveRecord::Migration[7.0]
  def change
    create_table :wallet_transaction_errors, id: :uuid do |t|
      t.references :wallet_transaction, type: :uuid, foreign_key: true, null: false
      t.string :error_type, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
