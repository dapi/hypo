# frozen_string_literal: true

class AccountsController < ApplicationController
  layout 'simple'

  before_action :require_login

  def index
    render locals: { accounts: current_user.accounts.order(:id) }
  end
end
