class AddLastNodeJobErrorMessage < ActiveRecord::Migration[8.0]
  def change
    add_column :nodes, :last_node_job_error_message, :string
  end
end
