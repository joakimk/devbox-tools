class SoftwareDependency < Dependency
  def install
    # This assumes ubuntu packages, but it could be adapted in combination with
    # adapting required_packages in each dependency for other distributions.
    #
    # Not an easy problem. Chef cookbooks usually do just that.
    #
    # Could be that ubuntu is good enough for most people, just like heroku's
    # standard platform works just fine for most people. Then we don't need
    # to put a lot of extra work into this.
    if required_packages.any? && !Devbox.offline?
      system("sudo apt-get install #{required_packages.join(' ')} -y -qq") ||
        raise("Failed to install required system packages for #{name}")
    end
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

  def required_packages
    []
  end

  def install_prefix
    # This must be a path that is the same on all machines and all projects because
    # many pieces of software hardcode their install path into scripts and binaries.
    #
    # Otherwise we won't be able to cache installs.
    "#{Devbox.code_root}/dependencies/#{name}"
  end

  def project_root
    Devbox.project_root
  end
end
