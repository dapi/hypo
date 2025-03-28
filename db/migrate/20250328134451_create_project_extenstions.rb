class CreateProjectExtenstions < ActiveRecord::Migration[8.0]
  def change
    create_table :project_extenstions, id: :uuid do |t|
      t.integer :blockchain_id, null: false
      t.string :title, null: false
      t.jsonb :params, null: false, default: {}
      t.string :extra_dataset_paths, array: true, null: false, default: []

      t.timestamps
    end
  end
end
