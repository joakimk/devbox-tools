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
    # mruby don't let you re-raise an exception without loosing history, so printing it
    puts
    puts ex.inspect

    puts
    # TODO: Color class
    puts "Some error occurred, try again with \e[1;33mDEBUG=t\e[0m for more info."
    exit 1
  end

  def self.commands
    @commands ||= []
  end
end
