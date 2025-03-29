class CreateNodes < ActiveRecord::Migration[8.0]
  def change
    create_table :nodes do |t|
      t.references :account, null: false, foreign_key: true
      t.string :key, null: false
      t.boolean :no_mining, null: false, default: false
      t.integer :block_time, null: false, default: 0

      t.timestamps
    end

    add_index :nodes, :key, unique: true
  end
end
