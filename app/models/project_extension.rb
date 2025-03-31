class ProjectExtension < ApplicationRecord
  include ListSupport

  belongs_to :blockchain
  belongs_to :account

  scope :alive, -> { all }

  validates :name, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true

  # SCHEMA = Rails.root.join('config', 'schemas', 'project_extension.json')
  # validates :params, json: { schema: SCHEMA }

  validates :params, json: true

  before_create do
    self.title ||= Faker::App.name
  end

  def set_defaults
    self.name ||= "abi"
    self.title ||= Faker::App.name
  end
end
