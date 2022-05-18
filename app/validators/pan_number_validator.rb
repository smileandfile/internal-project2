class PanNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    record.errors.add attribute, (options[:message] || "PAN number should be ten characters.") unless
      value.length == 10
    record.errors.add attribute, (options[:message] || "PAN Number entered is not in the correct format.") unless
      value =~ /[a-z]{3}[cphfatblj][a-z]\d{4}[a-z]/i
  end
end 
