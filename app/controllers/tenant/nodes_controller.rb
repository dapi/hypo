module Tenant
  class NodesController < ApplicationController
    include PaginationSupport
    include RansackSupport
  end
end
