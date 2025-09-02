class AddInstructionsToProject < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :instruction, :text
  end
end
