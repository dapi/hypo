class ProjectExtension < ApplicationRecord
  belongs_to :belockchain
  belongs_to :account

  scope :alive, -> { all }

  validates :name, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true

  before_create do
    self.name ||= Faker::App.name
  end

  def set_defaults
    self.name ||= Faker::App.name
  end
end
