require "#{File.dirname(__FILE__)}/devbox_tools"
$LOAD_PATH << "#{DevboxTools.root}/lib"

require "command_dispatcher"
require "dependency_registry"

# NOTE: There is something odd going on with "path", it's always "environment.rb". That's
# why each "map" and "each" in this file does not use "path" as the variable.

dependency_paths = DevboxTools.files("plugins", DevboxTools.devbox_root).flat_map { |dependency_path|
  DevboxTools.files("dependencies", dependency_path)
}.compact

# NOTE: When we/if get default dependencies, these will probably override those if they have the same name.
dependency_paths.each do |dependency_path|
  require dependency_path
end

DevboxTools.ruby_files("lib/commands").each do |command_path|
  require command_path
end
