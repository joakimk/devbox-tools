class File
  def self.readlines(path)
    read(path).split("\n").map { |line| "#{line}\n" }
  end

  def self.write(path, content)
    File.open(path, "wb") { |f| f.puts(content) }
  end
end

module YAML
  def self.load_file(path)
    self.load(File.read(path))
  end
end

class Hash
  def symbolize_keys(hash = self)
    hash.inject({}) { |result, entry|
      # mruby does not seem to support (k, v) in || above.
      key, value = entry

      new_key   = key.is_a?(String) ? key.to_sym            : key
      new_value = value.is_a?(Hash) ? symbolize_keys(value) : value

      result[new_key] = new_value
      result
    }
  end
end
