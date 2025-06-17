class CreateImageTags < ActiveRecord::Migration[8.0]
  def change
    create_table :image_tags do |t|
      t.string :tag, null: false
      t.string :repository, null: false
      t.string :description
      t.boolean :is_available, null: false, default: true
      t.boolean :is_current, null: false, default: true

      t.timestamps
    end

    add_index :image_tags, :tag, unique: true
    add_index :image_tags, %i[is_available tag]
    add_index :image_tags, :is_current
  end
end
