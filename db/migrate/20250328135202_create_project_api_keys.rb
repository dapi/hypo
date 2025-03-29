class CreateProjectApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :project_api_keys do |t|
      t.references :account, null: false, foreign_key: true
      t.string :secret_key

      t.timestamps
    end
  end
end
