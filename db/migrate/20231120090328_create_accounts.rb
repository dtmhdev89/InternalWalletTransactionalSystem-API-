class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :email, null: false
      t.string :type
      t.string :password_digest

      t.timestamps
    end
    add_index :accounts, :email, unique: true
  end
end
