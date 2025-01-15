# frozen_string_literal: true

class Setup < ActiveRecord::Migration[5.1]
  def up
    # Source is https://wiki.postgresql.org/wiki/Clone_schema
    execute Rails.root.join('db/functions/clone_schema.sql').read
  end
end
