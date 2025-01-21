class Account < ApplicationRecord
  include AccountSubdomain

  broadcasts_refreshes

  has_many :nodes
  has_many :memberships
  belongs_to :owner, class_name: "User"
  has_many :members, through: :memberships, source: :user

  validates :subdomain, exclusion: { in: ApplicationConfig.reserved_subdomains }

  after_create do
    self.members << owner
  end

  def title
    subdomain
  end
end
