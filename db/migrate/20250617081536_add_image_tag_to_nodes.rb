class AddImageTagToNodes < ActiveRecord::Migration[8.0]
  def change
    ImageTag.create!(tag: '0.0.1', description: 'anvil@0.53', repository: ApplicationConfig.anvil_default_repository)
    it = ImageTag.create!(tag: '0.0.2', description: 'anvil@1.2.3-dev', repository: ApplicationConfig.anvil_default_repository, is_current: true)
    add_reference :nodes, :image_tag, foreign_key: true

    Node.update_all image_tag_id: it.id

    change_column_null :nodes, :image_tag_id, false
  end
end
