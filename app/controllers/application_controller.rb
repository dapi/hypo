class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from HumanizedError, with: :humanized_error

  private

  def humanized_error(error)
    @simple_layout = "simple" unless defined?(Admin) && is_a?(Admin::ApplicationController)
    render "humanized_error", layout: @simple_layout, status: :forbidden, locals: { exception: error }
  end
end
