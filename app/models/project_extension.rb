class ProjectExtension < ApplicationRecord
  include ListSupport

  belongs_to :blockchain
  belongs_to :account
  belongs_to :extension

  scope :alive, -> { all }

  validates :title, presence: true, length: { minimum: 3, maximum: 64 }

  validate :validate_params_string

  before_save do
    # Уже провалидировали, поэтому сохранят не страшно
    self.params = ActiveSupport::JSON.decode(params.strip) if params.is_a?(String)
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

  def params_string
    @params_string ||= JSON.pretty_generate(params)
  end

  def params_string=(value)
    @params_string = value
    self.params = parse_json_string value
  rescue ParsingError
    # suppress
  end

  private

  ParsingError = Class.new StandardError

  def parse_json_string(value)
    data = ActiveSupport::JSON.decode(value) || {}
    raise ParsingError, "Must be a map/hash" unless data.is_a? Hash
    data
  rescue JSON::ParserError, TypeError => exception
    raise ParsingError, exception.message
  end

  def validate_params_string
    parse_json_string params_string
  rescue ParsingError => exception
    errors.add(:params_string, exception.message)
  end
end
