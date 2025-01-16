class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :subdomain, null: false
      t.references :owner, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end

    add_index :accounts, :subdomain, unique: true
  end
end
