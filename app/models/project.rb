class Project < ApplicationRecord
  belongs_to :account

  before_validation on: :create do
    self.name ||= Faker::Superhero.name
  end

  validates :name, uniqueness: { scope: :account_id }, presence: true
end
