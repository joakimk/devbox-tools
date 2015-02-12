class PluginFileFinder
  KNOWN_PLUGIN_DIRECTORIES = [
    "dependencies",
    "caches",
    "commands",
  ]

  def initialize(plugin_directories)
    @plugin_directories = plugin_directories
  end

  def plugin_files
    ruby_files.uniq { |path|
      File.basename(path)
    }
  end

  private

  def ruby_files
    plugin_directories.flat_map { |path|
      Finder.files(path).flat_map { |plugin_path|
        KNOWN_PLUGIN_DIRECTORIES.flat_map { |type|
          Finder.files("#{plugin_path}/#{type}")
        }
      }
    }
  end

  attr_reader :plugin_directories
end
