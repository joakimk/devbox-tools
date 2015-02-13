class BuildCommand < Command
  def options
    {
      "build" => "Rebuild a dependency. Takes a name."
    }
  end

  def run(_, parameters)
    dependency = find_dependency(parameters.first)

    if dependency
      log "Building dependency #{dependency.name}" do
        logger.detail "removing old version..."
        dependency.remove
        dependency.install(logger)
        dependency.status
      end
    else
      log "This project does not have any dependency named \"#{parameters.first}\".\n\nYou can only build a dependency within the context of a project that uses it so that the correct version is built."
    end
  end

  private

  def find_dependency(name)
    DependencyRegistry.dependencies_used_by_the_current_project.find { |d| d.name == name }
  end
end

CommandDispatcher.register(BuildCommand.new)
