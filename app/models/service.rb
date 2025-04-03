class Service < ApplicationRecord
  include ListSupport

  belongs_to :account
  belongs_to :blockchain

  scope :alive, -> { all }

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 64 }

  before_create do
    self.name ||= Faker::App.name
  end

  def set_defaults
    self.name ||= Faker::App.name
  end
end
