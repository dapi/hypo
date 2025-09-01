class Account < ApplicationRecord
  include AccountSubdomain
  ALPHABET = "1234567890abcdef"

  broadcasts_refreshes

  belongs_to :owner, class_name: "User"

  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :projects

  validates :subdomain, exclusion: { in: ApplicationConfig.reserved_subdomains }, presence: true

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
