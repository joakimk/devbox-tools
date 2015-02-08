class RunCommand
  def self.call(name, commands)
    new(name, commands).call
  end

  def initialize(name, commands)
    @name = name
    @commands = commands
  end

  def call
    if command
      command.run(name)
    else
      list_commands
    end
  end

  private

  def command
    commands.find { |command| command.match?(name) }
  end

  def list_commands
    puts "Available commands:"
    commands.flat_map(&:options).each do |option|
      puts menu_option(option)
    end
  end

  def menu_option(option)
    name, description = option

    option = "- #{name}"

    # String#ljust is not available in mruby.
    0.upto(20).map { |i|
      option[i] || " "
    }.join + "# #{description}"
  end

  attr_reader :name, :commands
end
