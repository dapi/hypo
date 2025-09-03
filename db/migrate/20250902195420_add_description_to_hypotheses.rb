class AddDescriptionToHypotheses < ActiveRecord::Migration[8.0]
  def change
    add_column :hypotheses, :description, :text
  end
end
