class AddApiKeyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :api_key, :string

    add_index :users, :api_key, unique: true

    User.find_each do |user|
      user.update! api_key: Nanoid.generate(size: 32)
    end

    change_column_null :users, :api_key, false
  end
end
