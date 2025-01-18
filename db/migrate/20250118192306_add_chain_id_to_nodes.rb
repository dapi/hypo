class AddChainIdToNodes < ActiveRecord::Migration[8.0]
  def change
    add_column :nodes, :chain_id, :integer, null: false, default: 31337
  end
end
