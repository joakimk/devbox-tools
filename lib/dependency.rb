class Dependency
  def name
    raise "implement name"
  end

  def environment_variables(previous_envs)
    previous_envs
  end

  def used_by_current_project?
    version
  end

  def config
    config_path = File.join(Devbox.project_root, "devbox.yml")

    if File.exists?(config_path)
      config_data = YAML.load_file(config_path).symbolize_keys
      custom = config_data.fetch(:dependencies).fetch(name.to_sym, {})
      default_config.merge(custom)
    else
      default_config
    end
  end

  def default_config
    {
      version: default_version
    }
  end

  def default_version
    nil
  end

  def cacheable?
    cacheable_path && cache_key
  end

  def cache_key
    "#{name}-#{version}"
  end

  def cacheable_path
    nil
  end

  def installed?
    true
  end

  def status
    "done"
  end

  def start
    # do nothing by default
  end

  def version
    "unversioned"
  end
end
