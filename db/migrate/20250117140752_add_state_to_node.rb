class AddStateToNode < ActiveRecord::Migration[8.0]
  def change
    add_column :nodes, :state, :string, null: false, default: 'initiated'
  end
end
