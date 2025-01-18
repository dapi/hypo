# frozen_string_literal: true

class ProfileController < ApplicationController
  layout "simple"

  before_action :require_login

  def show
    render locals: { user: current_user }
  end
end
