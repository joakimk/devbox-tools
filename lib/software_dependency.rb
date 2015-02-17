require "build"

class SoftwareDependency < Dependency
  def status
    installed? ? "#{version} installed (#{version_source})" : "not installed"
  end

  def cacheable_path
    install_prefix
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
    if required_packages.any? && !Devbox.offline?
      logger.detail("installing required system packages...")
      Shell.run "sudo apt-get install #{required_packages.join(' ')} -y"
    end

    unless installed?
      logger.detail("installing #{display_name}...")
      build_and_install
    end
  end

  def remove
    Shell.run("rm -rf #{install_prefix}")
  end

  def environment_variables(envs)
    envs["PATH"] = "#{install_prefix}/bin:#{envs["PATH"]}"
    envs
  end

  private

  # TODO: extract and unit test
  def version_source
    if version == configured_version
      default_version = default_config.fetch(:version, nil)

      if configured_version.to_s == default_version.to_s
        "default"
      else
        "configured"
      end
    elsif version == autodetected_version
      "autodetected"
    else
      "unknown version source"
    end
  end

  def version
    configured_version || autodetected_version
  end

  def configured_version
    config.fetch(:version, nil)
  end

  # implement in subclass if autodetection is possible
  def autodetected_version
    nil
  end

  def build_and_install
    build_step do
      build_and_install_command
    end
  end

  def build_step(&block)
    build.in_temporary_path(&block)
  end

  def build_path
    build.path
  end

  def build
    Build.new(name)
  end

  def build_and_install_command
    raise "implement me, or override build_and_install for completly custom installs"
  end

  def installed?
    File.exists?(install_prefix)
  end

  def required_packages
    []
  end

  def install_prefix
    # This must be a path that is the same on all machines and all projects because
    # many pieces of software hardcode their install path into scripts and binaries.
    #
    # Otherwise we won't be able to cache installs.
    "#{Devbox.software_dependencies_root}/#{name}-#{version}"
  end

  def project_root
    Devbox.project_root
  end
end
