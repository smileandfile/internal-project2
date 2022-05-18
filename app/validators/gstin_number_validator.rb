class GstinNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    record.errors.add attribute, (options[:message] || "Gstin_number should be fifteen characters") unless
      value.length == 15
    record.errors.add attribute, (options[:message] || "Gstin_number entered is not in the correct format.") unless
      value =~ /^[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9A-Za-z]{1}[Z]{1}[0-9a-zA-Z]{1}$/
  end
end 
