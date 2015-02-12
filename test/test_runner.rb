ENV["DEVBOX_DATA_ROOT"] = "/var/devbox_test"
ENV["DEVBOX_TEST"] = "true"
require "#{File.dirname(__FILE__)}/../lib/environment"

module TestHelpers
  # Run command in the devbox env and return the output
  def shell(command)
    exec_command(devbox_command(command))
  end

  # Run command in the devbox env and raise if it fails
  def shell!(command)
    system(devbox_command(command)) || raise("Command failed: #{command}")
  end

  def fixture_path(name)
    File.expand_path(File.join(File.dirname(__FILE__), "fixtures/#{name}"))
  end

  private

  def devbox_command(command)
    "cd $HOME && /bin/bash -c 'source $DEVBOX_TOOLS_ROOT/support/shell && #{command} 2>&1'"
  end
end

class MTest::Unit::TestCase
  include TestHelpers
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
