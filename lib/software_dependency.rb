require "build"

class SoftwareDependency < Dependency
  def cacheable_path
    install_prefix
  end

  def install(logger)
    super

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

  # Don't auto register an abstract class
  def self.autoregister?
    self != SoftwareDependency
  end
end
