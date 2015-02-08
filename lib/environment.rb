require "#{File.dirname(__FILE__)}/devbox"
$LOAD_PATH << "#{Devbox.tools_root}/lib"

require "command_dispatcher"
require "dependency_registry"
require "finder"
require "logger"

# NOTE: There is something odd going on with "path", it's always "environment.rb". That's
# why each "map" and "each" in this file does not use "path" as the variable.

dependency_paths = Finder.files("plugins", Devbox.root).flat_map { |dependency_path|
  Finder.files("dependencies", dependency_path)
}.compact

dependency_paths += Finder.files("lib/dependencies", Devbox.tools_root)

# NOTE: We don't support overriding default dependencies yet
dependency_paths.each do |dependency_path|
  require dependency_path
end

Finder.ruby_files("lib/commands").each do |command_path|
  require command_path
end
