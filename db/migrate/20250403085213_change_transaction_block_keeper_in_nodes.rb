class ChangeTransactionBlockKeeperInNodes < ActiveRecord::Migration[8.0]
  def change
    add_column :nodes, :transaction_block_keeper, :integer, default: 64
  end
end
