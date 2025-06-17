class NodeDecorator < ApplicationDecorator
  delegate_all

  def tag
    h.current_user.superadmin? ? object.image_tag.detailed_tag : object.image_tag.tag
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
