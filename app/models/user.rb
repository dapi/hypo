class User < ApplicationRecord
  include UserAppearance

  authenticates_with_sorcery!
  has_many :owner_accounts, class_name: "Account", foreign_key: :owner_id, dependent: :restrict_with_error,
                            inverse_of: :owner
  has_many :memberships, dependent: :delete_all
  has_many :accounts, through: :memberships

  belongs_to :telegram_user

  delegate :first_name, :public_name, :telegram_nick, to: :telegram_user

  ROLES = %w[user superadmin developer].freeze

  before_create { self.api_key ||= Nanoid.generate(size: 32) }

  enum :role, ROLES.each_with_object({}) { |key, a| a[key] = key }

  def default_account
    accounts.order(:created_at).first || owner_accounts.order(:created_at).first
  end

  def to_s
    public_name
  end

  def avatar_url
    telegram_user.photo_url
  end

  def self.find_or_create_by_telegram_data!(data)
    find_or_create_by!(
      telegram_user: TelegramUser.find_or_create_by_telegram_data!(data)
    )
  end

  def self.authenticate(telegram_data)
    yield(
      User.find_or_create_by_telegram_data!(telegram_data),
      nil)
  end

  def developer?
    role == "superadmin" || role == "developer"
  end

  def superadmin?
    role == "superadmin"
  end
end
