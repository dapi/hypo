class JsonValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid)
    super(options)
  end

  def validate_each(record, attribute, value)
    ActiveSupport::JSON.decode(value.strip) if value.is_a?(String)
  rescue JSON::ParserError, TypeError => exception
    record.errors.add(attribute, options[:message], exception_message: exception.message)
  end
end
