class CreateExtensions < ActiveRecord::Migration[8.0]
  def change
    create_table :extensions do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :extensions, :name, unique: true
    add_reference :project_extensions, :extension

    %w[abi new_contract].each do |name|
      e = Extension.find_or_create_by!(name: name)
      ProjectExtension.where(name: name).update_all extension_id: e.id
    end

    ProjectExtension.where(extension_id: nil).update_all extension_id: Extension.take.id
    remove_column :project_extensions, :name
    change_column_null :project_extensions, :extension_id, false
  end
end
