class ChangeDefaultMnemonic < ActiveRecord::Migration[8.0]
  def change
    change_column_default :nodes, :mnemonic, ApplicationConfig.default_mnemonic
  end
end
