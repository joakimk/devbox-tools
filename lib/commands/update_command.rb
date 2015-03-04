class UpdateCommand < Command
  include ConsoleLogger::Loggable

  def options
    {
      "update" => "Update devbox-tools and it's dependencies"
    }
  end

  def run(_option, _parameters)
    log "Updating devbox-tools" do
      ShellRunner.run("cd #{Devbox.tools_root} && git pull")
      nil
    end

    log "Updating devbox-tools dependencies" do
      ShellRunner.run("cd #{Devbox.tools_root} && sudo support/install_dependencies")
      nil
    end
  end
end

CommandDispatcher.register(UpdateCommand.new)
