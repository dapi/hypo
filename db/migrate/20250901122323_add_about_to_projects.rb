class AddAboutToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :about, :string
  end
end
