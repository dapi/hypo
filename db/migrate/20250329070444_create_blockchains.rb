class CreateBlockchains < ActiveRecord::Migration[8.0]
  def change
    create_table :blockchains do |t|
      t.integer :chain_id
      t.string :key
      t.string :name

      t.timestamps
    end
  end
end
