class Service < ApplicationRecord
  belongs_to :account
  belongs_to :blockchain

  scope :alive, -> { all }

  validates :name, presence: true, uniqueness: true

  before_create do
    self.name ||= Faker::App.name
  end

  def set_defaults
    self.name ||= Faker::App.name
  end
end
