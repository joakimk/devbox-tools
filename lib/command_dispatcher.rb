require "command"
require "run_command"

class CommandDispatcher
  def self.register(command)
    commands.push(command)
  end

  def self.run
    name = ARGV.first
    RunCommand.call(name, commands, ARGV[1..-1])
    EnvironmentVariables.update
  rescue => ex
    # TODO: Color class
    puts "Some error occurred, try again with \e[1;33mDEBUG=t\e[0m for more info."
    puts
    raise
  end

  def self.commands
    @commands ||= []
  end
end
