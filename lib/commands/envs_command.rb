class EnvsCommand < Command
  def options
    {
      "envs" => "Prints the project's environment variables"
    }
  end

  def run(_option, _parameters)
    EnvironmentVariables.print
  end
end

CommandDispatcher.register(EnvsCommand.new)
