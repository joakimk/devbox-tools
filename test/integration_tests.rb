require "#{ENV["DEVBOX_TOOLS_ROOT"]}/lib/devbox_tools"

module TestHelpers
  def devbox_bash(command)
    exec_command("/bin/bash -c 'source $DEVBOX_TOOLS_ROOT/support/shell && #{command}'")
  end
end

DevboxTools.ruby_files("test/integration").each do |path|
  require path
end

class MTest::Unit::TestCase
  include TestHelpers
end

puts
puts "Running integration tests:"
MTest::Unit.new.run
