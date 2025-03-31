class AddKeyToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :key, :string

    Account.find_each do |a|
      a.update! key: Nanoid.generate(size: 8)
    end

    change_column_null :accounts, :key, false

    add_index :accounts, :key, unique: true
  end
end
