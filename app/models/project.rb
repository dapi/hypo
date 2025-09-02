class Project < ApplicationRecord
  belongs_to :account

  before_validation on: :create do
    self.name ||= Faker::Superhero.name
  end

  validates :name, uniqueness: { scope: :account_id }, presence: true

  # Инструкции с которых начинается любой чат в этом проекте.
  # Что-то в духе:
  # Я пилю стартап в области финтеха
  def start_project_instruction
    "Я строю стартап в области #{about}"
  end
end
