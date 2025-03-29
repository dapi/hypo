class CreateProjectExtensions < ActiveRecord::Migration[8.0]
  def change
    create_table :project_extensions do |t|
      t.integer :blockchain_id, null: false
      t.string :title, null: false
      t.string :summary
      t.string :tag
      t.jsonb :params, null: false, default: {}
      t.string :extra_dataset_paths, array: true, null: false, default: []

      t.timestamps
    end
  end
end
