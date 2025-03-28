class CreateProjectApiKeys < ActiveRecord::Migration[8.0]
  def change
    create_table :project_api_keys, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :secret_key

      t.timestamps
    end
  end
end
