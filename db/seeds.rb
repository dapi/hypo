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

account.nodes.first_or_create!
