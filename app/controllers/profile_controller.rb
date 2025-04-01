# frozen_string_literal: true

class ProfileController < ApplicationController
  layout "simple"

  before_action :require_login

  before_action do
    @back_url = root_url if @back_url.blank?
  end

  def show
    render locals: { user: current_user }
  end

  def update
    current_user.update! params.require(:user).permit(:locale)
    render :show, locals: { user: current_user }, notice: "Профиль изменён", status: :unprocessable_entity
  end
end
