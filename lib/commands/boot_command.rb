# The core command of devbox-tools. This triggers installs and starts services if needed.

class BootCommand < Command
  def options
    {
      nil => "Get the project ready to go.",
      "stop" => "Stop services.",
    }
  end

  def run(option, _parameters)
    case option
    when nil
      boot
    when "stop"
      stop
    end
  end

  private

  def boot
    prepare_directories

    dependencies.each do |dependency|
      log "Checking #{dependency.name}" do
        install_dependency(dependency)
        dependency.status
      end
    end

    log "Starting services" do
      dependencies.each do |dependency|
        dependency.start(logger)
      end
      nil
    end

    log "Development environment ready"
  end

  def stop
    log "Stopping services" do
      dependencies.each do |dependency|
        dependency.stop(logger)
      end
      nil
    end
  end

  def prepare_directories
    prepare_directory(Devbox.data_root)
    prepare_directory(Devbox.project_data_root)
  end

  def install_dependency(dependency)
    return if dependency.installed?

    cache = Devbox.cache(dependency)

    if cache.exists?
      restore_dependency_from_cache(dependency, cache)
    else
      install_and_cache_dependency(dependency, cache)
    end
  end

  def restore_dependency_from_cache(dependency, cache)
    logger.detail "restoring cache..."
    cache.restore
    dependency.install(logger)
  end

  def install_and_cache_dependency(dependency, cache)
    dependency.install(logger)

    if dependency.cacheable?
      logger.detail "building cache..."
      cache.build
    end
  end

  def prepare_directory(path)
    return if File.exists?(path)
    user = ENV["USER"]
    Shell.run "sudo mkdir -p #{path} && sudo chown #{user} -R #{path}"
  end

  def dependencies
    DependencyRegistry.dependencies_used_by_the_current_project
  end
end

CommandDispatcher.register(BootCommand.new)
