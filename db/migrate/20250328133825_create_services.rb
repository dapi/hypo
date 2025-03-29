class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :blockchain_id
      t.jsonb :extra_dataset_paths, null: false, default: []

      t.timestamps
    end
  end
end
