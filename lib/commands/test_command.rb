class TestCommand < Command
  def list
    {
      "test" => "Run devbox-tools tests"
    }
  end

  def run(command)
    Finder.ruby_files("test").reverse.each do |path|
      next unless path.include?("tests.rb")
      system("devbox-tools-ruby #{path}") || exit(1)
    end
  end
end

CommandDispatcher.register(TestCommand.new)
