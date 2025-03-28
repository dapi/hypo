class Service < ApplicationRecord
  belongs_to :account

  validates :name, presence: true, uniquness: true

  before_create do
    self.name ||= Faker::App.name
  end
end
