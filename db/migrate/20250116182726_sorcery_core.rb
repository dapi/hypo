class SorceryCore < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email,            index: { unique: true }
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end
  end
end
