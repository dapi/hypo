class AddHowToHypotheses < ActiveRecord::Migration[8.0]
  def change
    add_column :hypotheses, :how, :text
  end
end
