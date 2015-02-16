class TestConfiguration < MTest::Unit::TestCase
  def test_reading_default_configuration_for_a_dependency
    Dir.chdir("/tmp")
    dependency = DependencyRegistry.list.find { |dep| dep.name == "test_software_dependency" }
    assert_equal({ something: "default", other: "more", version: nil }, dependency.config)
  end

  def test_reading_project_specific_configuration_for_a_dependency
    Dir.chdir(fixture_path("configured_project"))
    dependency = DependencyRegistry.list.find { |dep| dep.name == "test_software_dependency" }
    assert_equal({ something: "local", other: "more", version: nil }, dependency.config)
  end
end
