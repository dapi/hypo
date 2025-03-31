class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from HumanizedError, with: :humanized_error
  around_action :switch_locale

  private

  def humanized_error(error)
    @simple_layout = "simple" unless defined?(Admin) && is_a?(Admin::ApplicationController)
    render "humanized_error", layout: @simple_layout, status: :forbidden, locals: { exception: error }
  end

  def switch_locale(&action)
    locale = params[:locale] || current_user.try(:locale) || extract_locale_from_accept_language_header || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale_from_accept_language_header
    available_locales = I18n.available_locales.map(&:to_s)
    locale = request.env["HTTP_ACCEPT_LANGUAGE"].to_s.scan(/^[a-z]{2}/).first
    locale if available_locales.include? locale
  end

  def redirect_after_login
    if current_user.default_account.present?
      url = tenant_root_url(subdomain: current_user.default_account.subdomain)
      redirect_back_or_to url, allow_other_host: true, notice: t("flash.hi", username: current_user)
    else
      # TODO: На страницу создания аккаунта через тариф
      redirect_back_or_to root_url, notice: t("flash.hi", username: current_user)
    end
  end
end
