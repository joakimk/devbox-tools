module TestHelpers
  def devbox_bash(command)
    exec_command("/bin/bash -c 'source /vagrant/devbox-tools/support/shell && #{command}'")
  end
end

Dir.entries("/vagrant/devbox-tools/test/integration").reject { |e| e.start_with?(".") }.each do |file|
  require "/vagrant/devbox-tools/test/integration/#{file}"
end

class MTest::Unit::TestCase
  include TestHelpers
end

MTest::Unit.new.run
