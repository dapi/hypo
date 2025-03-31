class Account < ApplicationRecord
  include AccountSubdomain
  ALPHABET = '1234567890abcdef'

  broadcasts_refreshes

  belongs_to :owner, class_name: "User"

  has_many :nodes
  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :project_api_keys
  has_many :services
  has_many :project_extensions

  validates :subdomain, exclusion: { in: ApplicationConfig.reserved_subdomains }

  before_create do
    self.key ||= Nanoid.generate(size: 8, alphabet: ALPHABET)
  end

  after_create do
    self.members << owner
  end

  def title
    subdomain
  end
end
