class Devbox
  def self.root
    ENV["DEVBOX_ROOT"] || raise("Missing DEVBOX_ROOT")
  end

  def self.environment
    ENV["DEVBOX_ENV"] || raise("Missing DEVBOX_ENV")
  end

  def self.logger
    Logger.new
  end

  def self.cache(dependency)
    FileCache.new(dependency, local_cache_path)
  end

  def self.tools_root
    "#{Devbox.root}/devbox-tools"
  end

  # Where project specific code and data is stored, eg. databases, gems, ...
  def self.project_data_root
    "#{data_root}/projects/#{local_project_identifier}"
  end

  # Where software dependencies are stored, e.g. ruby, node, ...
  def self.software_dependencies_root
    "#{data_root}/dependencies"
  end

  def self.local_cache_path
    "#{data_root}/cache"
  end

  def self.metadata_path
    "#{data_root}/metadata"
  end

  def self.data_root
    "/var/devbox/#{environment}"
  end

  # An identifier of the project locally that is as unique as possible without
  # having to place a generated identifier within the project directory.
  #
  # Ideally it be only the project_name, but you might have the multiple
  # projects with the same name in different places.
  def self.local_project_identifier(root = project_root)
    [ project_name(root), Digest::MD5.hexdigest(root) ].join("-")
  end

  def self.global_project_identifier
    origin_url = Git.origin_url(project_root)
    GenerateGlobalProjectIdentifier.call(origin_url)
  end

  def self.project_name(root = project_root)
    File.basename(root)
  end

  def self.project_root
    Dir.pwd
  end

  def self.debug?
    ENV["DEBUG"]
  end
end
