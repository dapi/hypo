module ApplicationHelper
  def app_title
    ApplicationConfig.app_title
  end

  def back_link(url = nil)
    link_to "&larr; #{t('helpers.back')}".html_safe, url || root_path
  end

  def back_url
    params[:back_url] || @back_url || request.referer.presence || root_url # rubocop:disable Rails/HelperInstanceVariable
  end

  def current_url
    request.url
  end

  def spinner
    content_tag :div, class: "spinner-border", role: "status" do
      content_tag :span, class: "visually-hidden" do
        "Loading..."
      end
    end
  end

  def full_error_messages(form)
    return if form.object.errors.empty?

    content_tag :div, class: "alert alert-danger" do
      form.object.errors.full_messages.to_sentence
    end
  end

  def sort_column(column, title)
    return column unless defined? q

    sort_link q, column, title
  end

  # rubocop:disable Metrics/MethodLength
  def title_with_counter(title, count, hide_zero: true, css_class: "badge rounded-pill text-bg-light")
    buffer = ""
    buffer += title

    buffer += " "
    text = hide_zero && count.to_i.zero? ? "" : count.to_s
    if count.positive?
      buffer += content_tag(:span,
                            text,
                            class: css_class,
                            data: { title_counter: true, count: count.to_i })
    end

    buffer.html_safe
  end
  # rubocop:enable Metrics/MethodLength

  def controller_namespace
    parts = controller.class.name.split("::")
    return nil if parts.one?
    parts.first.parameterize.to_sym
  end
end
