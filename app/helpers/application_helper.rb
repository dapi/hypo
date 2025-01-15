module ApplicationHelper
  def app_title
    'Vilna'
  end

  def current_url
    request.url
  end

  def logged_in?
    authenticated?
  end

  def spinner
    content_tag :div, class: 'spinner-border', role: 'status' do
      content_tag :span, class: 'visually-hidden' do
        'Loading...'
      end
    end
  end

  def full_error_messages(form)
    return if form.object.errors.empty?

    content_tag :div, class: 'alert alert-danger' do
      form.object.errors.full_messages.to_sentence
    end
  end
end
