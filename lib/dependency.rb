class Dependency
  ## Naming

  def name
    raise "implement name in #{self}"
  end

  def display_name
    name.gsub("_", " ")
  end

  ### Installation

  def installed?
    true
  end

  def install(logger)
    unless version
      logger.detail("no version")
      return
    end

    # This assumes ubuntu packages, but it could be adapted in combination with
    # adapting required_packages in each dependency for other distributions.
    #
    # Not an easy problem. Chef cookbooks have if/else on dist-version when names differ.
    #
    # Could be that ubuntu is good enough for most people, just like heroku's
    # standard platform works just fine for most people. Then we don't need
    # to put a lot of extra work into this.
    if required_packages.any?
      logger.detail("installing required system packages...")
      Shell.run "sudo apt-get install #{required_packages.join(' ')} -y"
    end
  end

  # We only install autodetected or configured dependencies by default.
  #
  # A subclass can choose to add additional detection that would allow
  # a default version to be installed.
  #
  # For example: in a typical rails project it's very common to need a
  # version of node to compile assets, though the exact version is not
  # that important. The node dependency can autodetect that the project is
  # a rails project that needs asset compliation and choose to
  # return true here so that the default node version is installed.
  #
  # The same could go for all types databases, etc.
  #
  # If you wish to have your dependency installed by default in
  # all projects, inherit from SystemSoftwareDependency which
  # is just a regular SoftwareDependency that always returns true
  # when asked if it's used in the current project.
  def used_by_current_project?
    version && version_source != VersionChooser::DEFAULT
  end

  def status
    installed? ? "#{display_version} installed (#{version_source})" : "not installed"
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

  def display_version
    version
  end

  # default convention for providing checksum by config
  # the algorithm used may differ between dependencies (ex: sha1, sha256, md5)
  def checksum
    config.fetch(:checksum, nil)
  end

  ### Metadata

  # Scoped to the dependency and project
  #
  # Some metadata could be shared, but better to be safe by default.
  #
  # An example of something that should not be shared is saved information
  # on service ports.
  def project_metadata
    Metadata.new("#{name}-#{Devbox.local_project_identifier}")
  end

  # For the things you know can be shared, you can use this store
  def shared_metadata
    Metadata.new(name)
  end


  ### Dependency

  # A dependency might depend on other dependencies. This
  # is a list of names.
  def dependencies
    []
  end

  # System packages (apt packages, etc.)
  def required_packages
    []
  end

  # Some classes might want to opt-out of auto registration.
  def self.autoregister?
    true
  end


  ### Private

  def version_chooser
    VersionChooser.new(autodetected_version, configured_version, default_version)
  end

  def self.inherited(dependency)
    DependencyRegistry.register_class(dependency)
  end
end
