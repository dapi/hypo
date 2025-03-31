class ProjectApiKeyDecorator < Draper::Decorator
  delegate_all

  def public_access_key
    h.content_tag :code, object.public_access_key
  end

  def access_key
    h.content_tag :code, object.access_key
  end

  def secret_key
    h.content_tag :code, object.secret_key
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
