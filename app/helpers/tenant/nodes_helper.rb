module Tenant::NodesHelper
  def input_options(definition)
    case definition.fetch(:type)
    when :integer
      { input_html: { min: definition.fetch(:min, 0) } }
    when :boolean
     { wrapper: :custom_boolean_switch }
    else
      {}
    end
  end
end
