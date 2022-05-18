module SelectHashValues
  ### hash - the hash to select values from
  ### keys - An array with the keys of the hash that we want in the new hash
  ### key_renames - a Hash from key to the new key name. Optional
  def select_hash_values(hash, keys, key_renames = {})
    hash = hash.to_unsafe_h if hash.respond_to?(:to_unsafe_h)
    hash.delete_if { |key, value| value.blank? }
    filtered_hash = hash.select { |key, value| keys.include? key.to_sym }
    Hash[filtered_hash.map { |k, v| [key_renames[k.to_sym] || k, v] }].symbolize_keys!
  end
end
