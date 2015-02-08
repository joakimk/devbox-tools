require "command"

class CommandDispatcher
  def self.register(command)
    commands.push(command)
  end

  def self.run
    name = ARGV.first
    command = commands.find { |command| command.match?(name) }

    if command
      command.run(name)
    else
      puts "Available commands:"
      commands.each do |command|
        command.list.each do |name, description|
          puts "- #{name}\t\t\t# #{description}"
        end
      end
    end
  rescue => ex
    # mruby don't let you re-raise an exception without loosing history, so printing it
    puts
    puts ex.inspect

    puts
    # TODO: Color class
    puts "Some error occurred, try again with \e[1;33mDEBUG=t\e[0m for more info. You can also try offline mode by setting \e[1;33mOFFLINE=t\e[0m."
    exit 1
  end

  def self.commands
    @commands ||= []
  end
end
