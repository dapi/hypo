class AddUniquenessToProjectsName < ActiveRecord::Migration[8.0]
  def change
    change_column_null :projects, :name, false
    add_index :projects, :name, unique: true
  end
end
