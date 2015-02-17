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
    config = Config.load

    if config[:dependencies]
      dependency_config = config.fetch(:dependencies).fetch(name.to_sym, {})
      default_config.merge(dependency_config)
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

  def start(logger)
    # do nothing by default
  end

  def stop(logger)
    # do nothing by default
  end

  def version
    "unversioned"
  end
end
