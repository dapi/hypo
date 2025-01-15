# frozen_string_literal: true

# Альтернативы:
#
# http://railscasts.com/episodes/389-multitenancy-with-postgresql?view=asciicast
# http://jerodsanto.net/2011/07/building-multi-tenant-rails-apps-with-postgresql-schemas/
#
module Multitenancy
  extend self # rubocop:disable Style/ModuleFunction

  delegate :connection, to: TenantRecord

  def create(tenant, &)
    # Схема уже создается клонированием
    # connection.execute(%{CREATE SCHEMA "#{tenant}"})
    connection.execute(%{SELECT clone_schema('#{tenant_template}','#{tenant}')})
    Thread.current[:available_schemas] = nil
    switch(tenant, &) if block_given?
  end

  def switch(tenant)
    Thread.current[:current_tenant] = tenant
    connection.schema_search_path = tenant_search_path tenant
    yield if block_given?
  ensure
    reset if block_given?
  end

  def reset
    connection.schema_search_path = default_tenant_scheme
    Thread.current[:current_tenant] = nil
  end

  def current_tenant
    Thread.current[:current_tenant]
  end

  def tenant_schemas_to_migrate
    ['public'] + tenant_schemas
  end

  def tenant_schemas
    Account.tenant_names
  end

  def schema_exists?(schema)
    available_schemas.include? schema
  end

  def current_schemas
    connection.schema_search_path.split(/,\s+/)
  end

  def available_schemas
    Thread.current[:available_schemas] ||= fetch_available_schemas
  end

  def use_all_tenants
    saved_tenant = Thread.current[:current_tenant]
    connection.schema_search_path = tenant_schemas.join(',')
    Thread.current[:current_tenant] = nil
    yield
  ensure
    if saved_tenant
      switch current_tenant
    else
      reset
    end
  end

  def fetch_available_schemas
    connection.query(
      "SELECT nspname FROM pg_namespace WHERE nspname !~ '^pg_.*'"
    ).flatten
  end

  def tenant_search_path(tenant)
    if multiple_db?
      tenant
    else
      [tenant, 'public'].join(',')
    end
  end

  def drop(tenant)
    connection.execute(%(DROP SCHEMA "#{tenant}" CASCADE))
  end

  def multiple_db?
    true
  end

  def tenant_template
    multiple_db? ? 'public' : 'tenant_template'
  end

  def default_schema?
    current_schemas.include? tenant_template
  end

  def default_tenant_scheme
    'public'
  end
end
