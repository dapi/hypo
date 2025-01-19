class AddOrderIndexToNodes < ActiveRecord::Migration[8.0]
  def change
    add_index :nodes, %i[account_id created_at]
  end
end
