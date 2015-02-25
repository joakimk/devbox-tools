class NewPluginFileFinderTest < TestCase
  test "finds plugin files recursively" do
    base_path = fixture_path("new_plugin_file_finder1")
    plugin_directories = [ base_path ]
    finder = NewPluginFileFinder.new(plugin_directories)
    files = finder.library_files

    assert_equal 2, files.size
    assert_equal "#{base_path}/lib/foo_dependency/version.rb", files.first
    assert_equal "#{base_path}/lib/foo_dependency.rb", files.last
  end

  test "finds test files recursively" do
    base_path = fixture_path("new_plugin_file_finder1")
    plugin_directories = [ base_path ]
    finder = NewPluginFileFinder.new(plugin_directories)
    files = finder.test_files

    assert_equal 2, files.size
    assert_equal "#{base_path}/test/foo_dependency/version_test.rb", files.first
    assert_equal "#{base_path}/test/foo_dependency_test.rb", files.last
  end

  test "prefers files from plugins earlier in the load path list" do
    base_path1 = fixture_path("new_plugin_file_finder1")
    base_path2 = fixture_path("new_plugin_file_finder2")
    plugin_directories = [ base_path2, base_path1 ]
    finder = NewPluginFileFinder.new(plugin_directories)
    files = finder.library_files

    assert_equal 2, files.size
    assert_equal "#{base_path2}/lib/foo_dependency.rb", files.first
    assert_equal "#{base_path1}/lib/foo_dependency/version.rb", files.last
  end
end
