# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Соглашение на пагинацию в контроллерах
#
module PaginationSupport
  extend ActiveSupport::Concern
  included do
    helper_method :per_page, :page
  end

  private

  def per_page
    params[:per]
  end

  def page
    params[:page]
  end

  def per_page_default
    Rails.env.development? ? 50 : 100
  end

  def paginate(scope)
    scope
      .page(page)
      .per(per_page || per_page_default)
  end
end
