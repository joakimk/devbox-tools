class UpdateCommand < Command
  include Logger::Loggable

  def options
    {
      "update" => "Update devbox-tools and it's dependencies"
    }
  end

  def run(_)
    log "Updating devbox-tools" do
      Shell.run("cd #{Devbox.tools_root} && git pull")
      nil
    end

    log "Updating devbox-tools dependencies" do
      Shell.run("cd #{Devbox.tools_root} && sudo support/install_dependencies")
      nil
    end
  end
end

CommandDispatcher.register(UpdateCommand.new)
