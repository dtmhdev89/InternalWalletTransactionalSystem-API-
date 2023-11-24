class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :account, type: :uuid, null: false, foreign_key: true
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end
