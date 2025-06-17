# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
telegram_user = TelegramUser.
  create_with(
     "first_name"=>"Danil",
     "last_name"=>"Pismenny",
     "username"=>"pismenny",
     "photo_url"=>"https://t.me/i/userpic/320/3CYhSyogI0OC2gV3vV5rziFJFXlsStR4yi692YM-rGU.jpg",
  ).
  find_or_create_by!(id: 943084337)

user = User.find_or_create_by!(telegram_user_id: telegram_user.id)

user.update! role: 'superadmin'
account = Account
  .find_or_create_by!(owner: user, subdomain: 'demo')

account.memberships.find_or_create_by! user: user

account.nodes.first_or_create! image_tag: ImageTag.current

CHAIN_IDS = {
  "binance" => 56,
  "avalanche" => 43114,
  "ethereum" => 1,
  "optimism" => 10,
  "arbitrum" => 42161,
  "polygon" => 137,
  "base" => 8453
}

CHAIN_IDS.each_pair do |key, chain_id|
  Blockchain.
    create_with(key: key, name: key).
    find_or_create_by!(chain_id: chain_id)
end

%w[abi new_contract].each do |name|
  Extension.find_or_create_by!(name: name)
end
