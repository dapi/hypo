class ImageTag < ApplicationRecord
  validates :repository, presence: true
  validates :tag, presence: true, uniqueness: true

  def self.current
    where(is_current: true).last
  end

  def detailed_tag
    "#{tag} (#{description})"
  end
end
