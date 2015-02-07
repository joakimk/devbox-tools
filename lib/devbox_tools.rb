class DevboxTools
  def self.root
    "#{devbox_root}/devbox-tools"
  end

  def self.devbox_root
    ENV["DEVBOX_ROOT"] || raise("Missing DEVBOX_ROOT")
  end

  def self.code_root
    "/var/devbox/#{project_name}"
  end

  def self.project_name
    File.basename(Dir.pwd)
  end

  def self.project_root
    Dir.pwd
  end

  # TODO: These should probably be moved somewhere better
  def self.ruby_files(relative_path, root = DevboxTools.root)
    files(relative_path, root).select { |path| path.include?(".rb") }
  end

  def self.files(relative_path, root = DevboxTools.root)
    directory = "#{root}/#{relative_path}"
    found = Dir.entries(directory).
      reject { |name| name == "." || name == ".." }.
      map { |name| "#{directory}/#{name}" }
  rescue Exception => ex
    if ex.message == directory
      []
    else
      raise
    end
  end
end
