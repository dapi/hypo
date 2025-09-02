class Message < ApplicationRecord
  acts_as_message
  has_many_attached :attachments  # Required for file attachments
end
