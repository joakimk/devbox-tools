require "command"

class CommandDispatcher
  def self.register(command)
    @commands ||= []
    @commands << command
  end

  def self.run
    name = ARGV.first
    command = @commands.find { |command| command.match?(name) }

    if command
      command.run(name)
    else
      puts "Available commands:"
      @commands.each do |command|
        command.list.each do |name, description|
          puts "- #{name}\t\t\t##{description}"
        end
      end
    end
  end
end
