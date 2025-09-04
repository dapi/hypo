class AddReadGuidAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :read_guide_at, :timestamp
  end
end
