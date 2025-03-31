class ProjectApiKey < ApplicationRecord
  ALPHABET = '1234567890abcdef'
  belongs_to :account
  belongs_to :creator, class_name: 'User'

  scope :alive, -> { all }

  before_create do
    self.access_key ||= Nanoid.generate(size: 8, alphabet: ALPHABET)
    self.secret_key ||= Nanoid.generate(size: 32)
  end

  def public_access_key
    [account.key, access_key].join('-')
  end
end
