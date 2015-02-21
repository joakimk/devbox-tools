class PluginFileFinderTest < TestCase
  test "prefers local devbox plugins to devbox tools defaults" do
    base_path = fixture_path("plugin_finder_overrides")

    source_paths = [
      "#{base_path}/devbox/plugins",
      "#{base_path}/devbox-tools/lib",
    ]

    loader = PluginFileFinder.new(source_paths)
    assert_equal [
      "#{base_path}/devbox/plugins/ruby/ruby_dependency.rb",
      "#{base_path}/devbox-tools/lib/dependencies/python_dependency.rb",
      ], loader.plugin_files
  end

  test "ignores non plugin files" do
    base_path = fixture_path("plugin_finder_non_plugin_files")

    source_paths = [
      "#{base_path}/devbox-tools/lib",
    ]

    loader = PluginFileFinder.new(source_paths)
    assert_equal [], loader.plugin_files
  end

  test "finds all types of plugin files" do
    base_path = fixture_path("plugin_finder_all_types")

    source_paths = [
      "#{base_path}/devbox-tools/lib",
    ]

    loader = PluginFileFinder.new(source_paths)

    assert_equal 3, loader.plugin_files.size
  end
end
