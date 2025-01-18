class AddTitleToNodes < ActiveRecord::Migration[8.0]
  def change
    enable_extension "citext"
    add_column :nodes, :title, :citext

    Node.find_each do |node|
      node.update! title: Faker::App.name
    end

    add_index :nodes, [ :account_id, :title ], unique: true
    change_column_null :nodes, :title, false
  end
end
