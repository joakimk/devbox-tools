class Devbox
  def self.root
    ENV["DEVBOX_ROOT"] || raise("Missing DEVBOX_ROOT")
  end

  def self.tools_root
    "#{Devbox.root}/devbox-tools"
  end

  # Where code is stored, eg. ruby, gems, node, ...
  def self.project_code_root
    "#{code_root}/projects/#{local_project_identifier}"
  end

  def self.code_root
    "/var/devbox"
  end

  # An identifier of the project locally that is as unique as possible without
  # having to place a generated identifier within the project directory.
  def self.local_project_identifier(root = project_root)
    Digest::MD5.hexdigest(root)
  end

  def self.global_project_identifier
    origin_url = Git.origin_url(project_root)
    GenerateGlobalProjectIdentifier.call(origin_url)
  end

  def self.project_name
    File.basename(root)
  end

  def self.project_root
    Dir.pwd
  end

  def self.offline?
    ENV["OFFLINE"]
  end
end

