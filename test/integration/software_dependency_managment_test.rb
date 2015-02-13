class TestSoftwareDependencyManagement < MTest::Unit::TestCase
  def setup
    shell! "mkdir /tmp/test_project"
    shell! "mkdir -p /tmp/other/test_project"
  end

  def teardown
    shell! "rm -rf /tmp/test_project && rm -rf /tmp/other/test_project && rm -rf #{Devbox.software_dependencies_root} && rm -rf #{Devbox.local_cache_path}"
  end

  def test_installing
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    assert_include \
      shell("cd /tmp/test_project && test_command"),
      "command not found"
    shell "cd /tmp/test_project && dev"

    output = shell("cd /tmp/test_project && test_command")
    assert_equal "test-command-output 1.2.3\n", output
  end

  def test_not_installing_when_not_used_by_project
    shell "cd /tmp/test_project && dev"

    output = shell("cd /tmp/test_project && test_command")
    assert_include output, "command not found"
  end

  def test_two_projects_with_the_same_name_in_different_places_does_not_collide
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/test_project && dev"
    assert_include output, "test_software_dependency"

    shell "cd /tmp/other/test_project && dev"
    output = shell("cd /tmp/other/test_project && test_command")
    assert_include output, "command not found"
    assert_not_include output, "test_software_dependency"
  end

  def test_two_projects_using_the_same_dependency_only_installs_once
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/test_project && dev"
    assert_include output, "installing"

    shell "echo '1.2.3' > /tmp/other/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/other/test_project && dev"
    assert_not_include output, "installing"
  end

  def test_two_versions_of_the_same_software_can_be_installed
    shell "echo '1.2.1' > /tmp/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/test_project && dev"
    assert_include output, "installing"

    shell "echo '1.2.5' > /tmp/other/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/other/test_project && dev"
    assert_include output, "installing"
  end

  def test_reinstalling_will_use_cached_version
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"

    output = shell "cd /tmp/test_project && dev"
    assert_include output, "installing"
    assert_include output, "building cache"

    system("rm -rf #{Devbox.software_dependencies_root}")

    output = shell "cd /tmp/test_project && dev"
    assert_include output, "restoring cache"
    assert_not_include output, "installing"

    # do nothing when already installed
    output = shell "cd /tmp/test_project && dev"
    assert_not_include output, "cache"
    assert_not_include output, "installing"
  end
end
