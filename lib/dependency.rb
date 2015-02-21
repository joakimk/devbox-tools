class Dependency
  ## Naming

  def name
    raise "implement name"
  end

  def display_name
    name.gsub("_", " ")
  end

  ### Installation

  def installed?
    true
  end

  def used_by_current_project?
    version
  end

  def status
    "done"
  end


  ### Environment

  def environment_variables(previous_envs)
    previous_envs
  end


  ### Config

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
      version: nil
    }
  end


  ### Service

  def start(logger)
    # do nothing by default
  end

  def stop(logger)
    # do nothing by default
  end


  ### Caching

  def cacheable?
    cacheable_path && cache_key
  end

  def cache_key
    "#{name}-#{version}"
  end

  def cacheable_path
    nil
  end


  ## Version

  def version
    version_chooser.version
  end

  def version_source
    version_chooser.version_source
  end

  def configured_version
    config.fetch(:version, nil)
  end

  # implement in subclass if autodetection is possible
  def autodetected_version
    nil
  end

  # implement in subclass if there is good default
  def default_version
    nil
  end


  ### Private

  def version_chooser
    VersionChooser.new(autodetected_version, configured_version, default_version)
  end
end
