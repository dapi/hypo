class ChangeDefaultBlockTimeToOneInNodes < ActiveRecord::Migration[8.0]
  def change
    change_column_default :nodes, :block_time, 1
  end
end
