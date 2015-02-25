class NewPluginFileFinder
  def initialize(plugin_directories)
    @plugin_directories = plugin_directories
  end

  def library_files
    list_files - test_files
  end

  def test_files
    list_files.select { |path|
      m = path.match(/.*_(.+?)\.rb/)
      m && m[1] == "test"
    }
  end

  private

  def list_files
    plugin_directories.flat_map { |plugin_path|
      recursive_list(plugin_path)
    }.uniq { |path|
      path_relative_to_plugin(path, plugin_directories)
    }.select { |path|
      path.match(/\.rb/)
    }
  end

  def path_relative_to_plugin(path, plugin_directories)
    plugin_directories.map { |plugin_path|
      if path.include?(plugin_path)
        path.sub(plugin_path, '')
      else
        nil
      end
    }.compact.first
  end

  def recursive_list(path)
    ls(path).flat_map do |path|
      begin
        recursive_list(path)
      rescue => ex
        if ex.message == path
          [ path ]
        else
          raise ex
        end
      end
    end
  end

  def ls(path)
    Dir.entries(path).
      reject { |name| name == "." || name == ".." }.
      map { |name| File.join(path, name) }
  end

  attr_reader :plugin_directories
end
