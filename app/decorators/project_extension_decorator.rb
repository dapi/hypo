class ProjectExtensionDecorator < ApplicationDecorator
  delegate_all

  def extension
    h.content_tag :code do
      object.extension.name
    end
  end

  def params
    h.expose_json object.params
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
