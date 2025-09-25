class AddSessionDataToTelegramUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :telegram_users, :session_data, :jsonb, null: false, default: {}
  end
end
