class TestCommand < Command
  def options
    {
      "test" => "Run devbox-tools tests",
      "test:unit" => "Run devbox-tools unit tests",
    }
  end

  def run(option)
    Finder.ruby_files("test").reverse.each do |path|
      next unless path.include?("tests.rb")
      next if option == "test:unit" && !path.include?("unit")

      system("devbox-tools-ruby #{path}") || exit(1)
    end
  end
end

CommandDispatcher.register(TestCommand.new)
