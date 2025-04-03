class ProjectExtension < ApplicationRecord
  include ListSupport

  belongs_to :blockchain
  belongs_to :account
  belongs_to :extension

  scope :alive, -> { all }

  validates :title, presence: true

  # SCHEMA = Rails.root.join('config', 'schemas', 'project_extension.json')
  # validates :params, json: { schema: SCHEMA }
  validates :params, json: true

  before_save do
    self.params = ActiveSupport::JSON.decode(params.strip) if value.is_a?(String)
  end

  # validates :params, json: true

  before_create do
    self.title ||= Faker::App.name
  end

  def set_defaults
    self.extension ||= Extension.default
    self.title ||= Faker::App.name
  end

  def to_s
    name
  end
end
