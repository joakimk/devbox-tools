class RunCommand
  def self.call(name, commands, parameters)
    new(name, commands, parameters).call
  end

  def initialize(name, commands, parameters)
    @name = name
    @commands = commands
    @parameters = parameters
  end

  def call
    if command
      command.run(name, parameters)
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
    require "pp"
    all_options = commands.each_with_object({}) { |command, h| h.merge!(command.options) }
    all_options.to_a.sort_by { |name, _| name.to_s }.each do |option|
      puts menu_option(option)
    end
  end

  def menu_option(option)
    name, description = option

    option = "- #{name}"
    option.ljust(20) + "# #{description}"
  end

  attr_reader :name, :commands, :parameters
end
