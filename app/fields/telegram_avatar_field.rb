require "administrate/field/base"

class TelegramAvatarField < Administrate::Field::String
  def to_s
    data
  end
end
