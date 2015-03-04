class Hash
  def symbolize_keys(hash = self)
    hash.inject({}) { |result, (key, value)|
      new_key   = key.is_a?(String) ? key.to_sym            : key
      new_value = value.is_a?(Hash) ? symbolize_keys(value) : value

      result[new_key] = new_value
      result
    }
  end
end
