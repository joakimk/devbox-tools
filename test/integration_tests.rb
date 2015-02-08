$LOAD_PATH << File.join(ENV["DEVBOX_TOOLS_ROOT"], "lib")
require "finder"

module TestHelpers
  # Run command in the devbox env and return the output
  def shell(command)
    exec_command(devbox_command(command))
  end

  # Run command in the devbox env and raise if it fails
  def shell!(command)
    system(devbox_command(command)) || raise("Command failed: #{command}")
  end

  private

  def devbox_command(command)
    "/bin/bash -c 'source $DEVBOX_TOOLS_ROOT/support/shell && #{command} 2>&1'"
  end
end

Finder.ruby_files("test/integration").each do |path|
  require path
end

class MTest::Unit::TestCase
  include TestHelpers
end

puts
puts "Running integration tests:"
MTest::Unit.new.run
