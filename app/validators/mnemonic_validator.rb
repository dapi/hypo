class MnemonicValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid)
    super(options)
  end

  def validate_each(record, attribute, value)
    BipMnemonic.checksum BipMnemonic.to_entropy mnemonic: value
  rescue IndexError, ArgumentError => exception
    record.errors.add(attribute, options[:message] || exception.message, exception_message: exception.message)
  end
end
