require "#{File.dirname(__FILE__)}/devbox_tools"
$LOAD_PATH << "#{DevboxTools.root}/lib"
require "command_dispatcher"

DevboxTools.ruby_files("lib/commands").each do |path|
  require path
end

CommandDispatcher.run
