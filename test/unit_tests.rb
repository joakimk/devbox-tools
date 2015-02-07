require "#{File.dirname(__FILE__)}/../lib/environment"

Finder.ruby_files("test/unit").each do |path|
  require path
end

puts "Running unit tests:"
MTest::Unit.new.run
