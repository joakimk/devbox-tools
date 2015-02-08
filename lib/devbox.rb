class Devbox
  def self.root
    ENV["DEVBOX_ROOT"] || raise("Missing DEVBOX_ROOT")
  end

  def self.tools_root
    "#{Devbox.root}/devbox-tools"
  end

  # Where code is stored, eg. ruby, gems, node, ...
  def self.project_code_root
    "#{code_root}/projects/#{project_name}"
  end

  def self.code_root
    "/var/devbox"
  end

  def self.project_name
    File.basename(project_root)
  end

  def self.project_root
    Dir.pwd
  end

  def self.offline?
    ENV["OFFLINE"]
  end
end

