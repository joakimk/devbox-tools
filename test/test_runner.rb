ENV["DEVBOX_ENV"] = "test"
require "#{File.dirname(__FILE__)}/../lib/environment"

unless File.exists?("/usr/bin/zsh")
  puts "You need zsh installed to run devbox-tools tests (expected to be at /usr/bin/zsh)"
  exit 1
end

module TestHelpers
  # Run command in the devbox env and return the output
  def shell(command)
    exec_command(devbox_command(command))
  end

  # Run command in the devbox env and raise if it fails
  def shell!(command)
    system(devbox_command(command)) || raise("Command failed: #{command}")
  end

  def zsh_shell(command)
    exec_command(devbox_command(command, "zsh"))
  end

  def fixture_path(name)
    File.expand_path(File.join(File.dirname(__FILE__), "fixtures/#{name}"))
  end

  private

  def devbox_command(command, shell = "bash")
    %{
      #{shell} -c '
        export HOME=#{ENV["HOME"]} &&
        export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin &&
        export DEVBOX_ENV=test &&
        export SHELL=#{shell} &&
        cd $HOME &&
        source #{ENV["DEVBOX_TOOLS_ROOT"]}/support/shell &&
        #{command} 2>&1'
    }
  end
end

class TestCase < MTest::Unit::TestCase
  include TestHelpers

  # Adds a test syntax that is more reading, writing and editing friendly :)
  #
  # Typing:
  # test "converts foo to bar" do; end
  #
  # Generates:
  # def test_converts_foo_to_bar; end
  def self.test(name, &block)
    define_method(test_method_name(name), &block)
  end

  # Mark a test as pending
  def self.xtest(name)
    define_method(test_method_name(name)) do
      puts "[PENDING] #{self.to_s.match(/#<(.+?):/)[1]}: #{name}"
    end
  end

  def self.test_method_name(name)
    "test_#{name.gsub(/\W/, "_")}"
  end

end

class TestCase < MTest::Unit::TestCase
end

# Load tests
test_files = ARGV.select { |f| f.end_with?("_test.rb") }
test_files.each do |path|
  # converts both full paths and project relative paths to a path that is relative to this directory
  relative_path = path.gsub(/.+?test\//, "").gsub(/test\//, "")

  full_path = File.expand_path(File.join(File.dirname(__FILE__), relative_path))
  require full_path
end

exit MTest::Unit.new.run
