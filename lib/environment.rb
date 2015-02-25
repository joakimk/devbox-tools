require "#{File.dirname(__FILE__)}/devbox"
$LOAD_PATH << "#{Devbox.tools_root}/lib"

require "generate_global_project_identifier"
require "command_dispatcher"
require "dependency_registry"
require "dependency"
require "service_dependency"
require "software_dependency"
require "system_software_dependency"
require "finder"
require "new_plugin_file_finder"
require "plugin_file_finder"
require "logger"
require "shell"
require "git"
require "caches/file_cache"
require "extensions"
require "environment_variables"
require "config"
require "metadata"
require "version_chooser"

plugin_directories = []
plugin_directories << "#{Devbox.tools_root}/test/plugins" if Devbox.environment == "test"
plugin_directories << "#{Devbox.root}/plugins"
plugin_directories << "#{Devbox.tools_root}/lib"

PluginFileFinder.new(plugin_directories).plugin_files.each do |plugin_path|
  Devbox.logger.debug __FILE__, "Loading #{plugin_path}"
  require plugin_path
end

DependencyRegistry.load
