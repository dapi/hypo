class Tenant::DashboardController < ApplicationController
  before_action do
    @back_url = :hide
  end
  layout "simple"
end
