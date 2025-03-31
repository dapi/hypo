class CreateProjectApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :project_api_keys do |t|
      t.references :account, null: false, foreign_key: true
      t.references :creator, foreign_key: { to_table: :users }
      t.string :secret_key, null: false
      t.string :access_key, null: false

      t.timestamps
    end

    add_index :project_api_keys, :access_key, unique: true
  end
end
