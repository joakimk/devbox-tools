# The core command of devbox-tools. This triggers installs and starts services if needed.

class BootCommand < Command
  def list
    {
      nil => "Get the project ready to go."
    }
  end

  def run(_)
    prepare_directories

    dependencies.each do |dependency|
      log "Checking dependency #{dependency.name}" do
        dependency.install
        dependency.status
      end
    end

    log "Starting services" do
      dependencies.each(&:start)
      nil
    end

    log "Development environment ready"
  end

  private

  def prepare_directories
    prepare_directory(Devbox.code_root)
  end

  def prepare_directory(path)
    return if File.exists?(path)
    user = ENV["USER"]
    system("sudo mkdir -p #{path} && sudo chown #{user} -R #{path}")
  end

  def dependencies
    DependencyRegistry.dependencies_used_by_the_current_project
  end
end

CommandDispatcher.register(BootCommand.new)
