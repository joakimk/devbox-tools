class TestPluginFileFinder < MTest::Unit::TestCase
  def test_prefers_local_devbox_plugins_to_devbox_tools_defaults
    base_path = fixture_path("plugin_finder_overrides")

    source_paths = [
      "#{base_path}/devbox/plugins",
      "#{base_path}/devbox-tools",
    ]

    loader = PluginFileFinder.new(source_paths)
    assert_equal [
      "#{base_path}/devbox/plugins/ruby/dependencies/ruby_dependency.rb",
      "#{base_path}/devbox-tools/lib/dependencies/python_dependency.rb",
      ], loader.plugin_files
  end

  def test_ignores_non_plugin_files
    base_path = fixture_path("plugin_finder_non_plugin_files")

    source_paths = [
      "#{base_path}/devbox-tools",
    ]

    loader = PluginFileFinder.new(source_paths)
    assert_equal [], loader.plugin_files
  end

  def test_finds_all_types_of_plugin_files
    base_path = fixture_path("plugin_finder_all_types")

    source_paths = [
      "#{base_path}/devbox-tools",
    ]

    loader = PluginFileFinder.new(source_paths)

    assert_equal 3, loader.plugin_files.size
  end
end
