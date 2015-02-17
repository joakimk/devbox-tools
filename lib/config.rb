class Config
  def self.load
    config_path = File.join(Devbox.project_root, "devbox.yml")

    if File.exists?(config_path)
      YAML.load_file(config_path).symbolize_keys
    else
      {}
    end
  end
end
