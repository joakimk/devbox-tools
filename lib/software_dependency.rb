require "build"

class SoftwareDependency < Dependency
  def status
    installed? ? "#{version} installed (TODO: version source)" : "not installed"
  end

  def install(logger)
    return if installed?

    # This assumes ubuntu packages, but it could be adapted in combination with
    # adapting required_packages in each dependency for other distributions.
    #
    # Not an easy problem. Chef cookbooks have if/else on dist-version when names differ.
    #
    # Could be that ubuntu is good enough for most people, just like heroku's
    # standard platform works just fine for most people. Then we don't need
    # to put a lot of extra work into this.
    if required_packages.any? && !Devbox.offline?
      logger.inline("installing required system packages...")
      Shell.run "sudo apt-get install #{required_packages.join(' ')} -y"
    end

    logger.inline("installing #{name}...")
    build_and_install
  end

  def start
    # no-op
  end

  def environment_variables(envs)
    return envs unless used_by_current_project?
    envs["PATH"] = "#{install_prefix}/bin:#{envs["PATH"]}"
    envs
  end

  private

  def build_and_install
    raise "implement me in subclass to install to install_prefix"
  end

  def run_build(&block)
    Build.new(name).in_temporary_path(&block)
  end

  def version
    raise "implement me in subclass, return nil if no version is found"
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
    "#{Devbox.code_root}/dependencies/#{name}-#{version}"
  end

  def project_root
    Devbox.project_root
  end
end
