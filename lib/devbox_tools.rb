class DevboxTools
  def self.root
    ENV["DEVBOX_TOOLS_ROOT"] || raise("Missing DEVBOX_TOOLS_ROOT")
  end

  def self.ruby_files(relative_path)
    directory = "#{DevboxTools.root}/#{relative_path}"
    Dir.entries(directory).
      select { |e| e.end_with?(".rb") }.
      map { |name| "#{directory}/#{name}" }
  end
end
