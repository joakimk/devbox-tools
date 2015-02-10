class TestCommand < Command
  def options
    {
      "test" => "Run devbox-tools tests",
      "test:unit" => "Run devbox-tools unit tests",
    }
  end

  def run(option, parameters)
    if parameters.any?
      run_tests(parameters)
    else
      if option == "test:unit"
        run_tests Finder.ruby_files("test/unit")
      else
        run_tests Finder.ruby_files("test/unit") + Finder.ruby_files("test/integration")
      end
    end
  end

  private

  def run_tests(paths)
    system("devbox-tools-ruby #{test_runner_path} #{paths.join(' ')}") || exit(1)
  end

  def test_runner_path
    "#{Devbox.tools_root}/test/test_runner.rb"
  end
end

CommandDispatcher.register(TestCommand.new)
