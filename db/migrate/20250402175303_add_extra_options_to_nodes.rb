class AddExtraOptionsToNodes < ActiveRecord::Migration[8.0]
  def change
    Node::ARGUMENTS.each_pair do |key, definition|
      Node.reset_column_information
      next if Node.attribute_names.include? key.underscore
      add_column :nodes, key.underscore, definition.fetch(:type), default: definition.fetch(:default)
    end
  end
end
