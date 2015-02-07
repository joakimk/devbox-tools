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
          puts "- #{name}\t\t\t##{description}"
        end
      end
    end
  end

  def self.commands
    @commands ||= []
  end
end
