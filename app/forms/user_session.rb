# frozen_string_literal: true

class UserSession
  extend  ActiveModel::Naming

  include ActiveModel::Attributes
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :email, :string
  attribute :code, :string

  validates :email, presence: true
  validates :code, presence: true

  def persisted?
    false
  end
end
