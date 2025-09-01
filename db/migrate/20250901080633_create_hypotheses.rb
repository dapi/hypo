class CreateHypotheses < ActiveRecord::Migration[8.0]
  def change
    create_table :hypotheses do |t|
      t.references :project, null: false, foreign_key: true
      t.text :draft
      t.text :formulated
      t.text :actions
      t.text :data
      t.text :insights
      t.text :comments
      t.integer :beilef_in_success
      t.integer :simplicity
      t.string :status

      t.timestamps
    end
  end
end
