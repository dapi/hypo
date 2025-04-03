class User < ApplicationRecord
  include UserAppearance

  authenticates_with_sorcery!
  has_many :owner_accounts, class_name: "Account", foreign_key: :owner_id, dependent: :restrict_with_error,
                            inverse_of: :owner
  has_many :memberships, dependent: :delete_all
  has_many :accounts, through: :memberships
  has_many :nodes, through: :accounts

  belongs_to :telegram_user, optional: true

  validates :email, email: true, if: :email?

  delegate :first_name, :public_name, :telegram_nick, to: :telegram_user, allow_nil: true

  ROLES = %w[user superadmin developer].freeze

  before_create { self.api_key ||= Nanoid.generate(size: 32) }


  enum :role, ROLES.each_with_object({}) { |key, a| a[key] = key }

  def default_account
    accounts.order(:created_at).first || owner_accounts.order(:created_at).first
  end

  def to_s
    telegram_user.present? ? public_name : email.split.first
  end

  def avatar_url
    telegram_user.try(:photo_url) || Gravatar.src(email)
  end

  def self.find_or_create_by_telegram_data!(data)
    create_with(locale: I18n.locale).
      find_or_create_by!(
        telegram_user: TelegramUser.find_or_create_by_telegram_data!(data)
      )
  end

  def self.find_or_create_by_telegram_id!(tid)
    create_with(locale: I18n.locale).
      find_or_create_by!(
        telegram_user_id: tid
      )
  end

  def self.authenticate(data)
    if data.is_a? UserSession
      yield create_with(locale: I18n.locale).find_or_create_by!(email: data.email)
    else
      yield(
        data.is_a?(String) ? User.find_or_create_by_telegram_id!(data) : User.find_or_create_by_telegram_data!(data),
        nil)
    end
  end

  def developer?
    role == "superadmin" || role == "developer"
  end

  def superadmin?
    role == "superadmin"
  end
end
