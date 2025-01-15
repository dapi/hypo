class Tenant::ApplicationController < ApplicationController
  before_action :require_authentication
end
