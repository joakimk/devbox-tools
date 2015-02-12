class PluginFileFinder
  KNOWN_PLUGIN_TYPES = [
    "dependency",
    "cache",
    "command",
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
        Finder.files(plugin_path).select { |path|
          m = path.match(/.*_(.+?)\.rb/)
          m && KNOWN_PLUGIN_TYPES.include?(m[1])
        }
      }
    }
  end

  attr_reader :plugin_directories
end
