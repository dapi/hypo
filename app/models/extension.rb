class Extension < ApplicationRecord
  def self.default
    first
  end
end
