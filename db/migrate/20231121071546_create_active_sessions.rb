class CreateActiveSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :active_sessions, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :user_agent
      t.string :ip_address

      t.timestamps
    end
  end
end
