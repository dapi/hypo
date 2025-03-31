# frozen_string_literal: true

class EmailForm < ApplicationForm
  attribute :email, :string
  validates :email, presence: true

  def persisted?
    false
  end
end
