class SoftwareDependencyManagementTest < TestCase
  def setup
    shell! "mkdir /tmp/test_project"
    shell! "mkdir -p /tmp/other/test_project"
  end

  def teardown
    shell! "rm -rf /tmp/test_project && rm -rf /tmp/other/test_project && rm -rf #{Devbox.software_dependencies_root} && rm -rf #{Devbox.local_cache_path}"
  end

  test "installing" do
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    assert_include \
      shell("cd /tmp/test_project && test_command"),
      "command not found"
    shell "cd /tmp/test_project && dev"

    output = shell("cd /tmp/test_project && test_command")
    assert_equal "test-command-output 1.2.3\n", output
  end

  test "not installing when not used by project" do
    shell "cd /tmp/test_project && dev"

    output = shell("cd /tmp/test_project && test_command")
    assert_include output, "command not found"
  end

  test "two projects with the same name in different places does not collide" do
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/test_project && dev"
    assert_include output, "test software dependency"

    shell "cd /tmp/other/test_project && dev"
    output = shell("cd /tmp/other/test_project && test_command")
    assert_include output, "command not found"
    assert_not_include output, "test software dependency"
  end

  test "two projects using the same dependency only installs once" do
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/test_project && dev"
    assert_include output, "installing test software dependency..."

    shell "echo '1.2.3' > /tmp/other/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/other/test_project && dev"
    assert_not_include output, "installing test software dependency..."
  end

  test "two versions of the same software can be installed" do
    shell "echo '1.2.1' > /tmp/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/test_project && dev"
    assert_include output, "installing test software dependency..."

    shell "echo '1.2.5' > /tmp/other/test_project/.some_file_with_a_version"
    output = shell "cd /tmp/other/test_project && dev"
    assert_include output, "installing test software dependency..."
  end

  test "reinstalling will use cached version" do
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"

    output = shell "cd /tmp/test_project && dev"
    assert_include output, "installing test software dependency..."
    assert_include output, "building cache"

    system("rm -rf #{Devbox.software_dependencies_root}")

    output = shell "cd /tmp/test_project && dev"
    assert_include output, "restoring cache"
    assert_not_include output, "installing test software dependency..."

    # do nothing when already installed
    output = shell "cd /tmp/test_project && dev"
    assert_not_include output, "cache"
    assert_not_include output, "installing test software dependency..."
  end

  test "installing configured version" do
    output = shell "cd #{fixture_path("project_configured_as_2_0")} && dev"
    assert_include output, "installing test software dependency..."
    assert_include output, "2.0 installed (configured)"
  end

  test "does only install a default version if the specific dependency can detect that it's applicable" do
    output = shell "cd #{fixture_path("project_using_nothing")} && dev"
    assert_not_include output, "installing test software dependency..."

    output = shell "cd #{fixture_path("project_that_can_use_test_software_dependency_default")} && dev"
    assert_include output, "installing test software dependency..."
    assert_include output, "1.0 installed (default)"
  end
end
