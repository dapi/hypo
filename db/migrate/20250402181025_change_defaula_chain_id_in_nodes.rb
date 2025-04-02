class ChangeDefaulaChainIdInNodes < ActiveRecord::Migration[8.0]
  def up
    change_column_default :nodes, :chain_id, 56
  end
  def down
    change_column_default :nodes, :chain_id, 56
  end
end
