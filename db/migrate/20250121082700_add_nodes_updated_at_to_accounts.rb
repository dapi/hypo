class AddNodesUpdatedAtToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :nodes_updated_at, :timestamp
  end
end
