class ConfigurationTest < TestCase
  test "reading default configuration for a dependency" do
    Dir.chdir("/tmp")
    dependency = DependencyRegistry.list.find { |dep| dep.name == "test_software_dependency" }
    assert_equal({ something: "default", other: "more", version: nil }, dependency.config)
  end

  test "reading project specific configuration for a dependency" do
    Dir.chdir(fixture_path("configured_project"))
    dependency = DependencyRegistry.list.find { |dep| dep.name == "test_software_dependency" }
    assert_equal({ something: "local", other: "more", version: nil }, dependency.config)
  end
end
