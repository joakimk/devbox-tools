class TestSoftwareDependencyManagement < MTest::Unit::TestCase
  def setup
    devbox_bash "mkdir /tmp/test_project"
  end

  def teardown
    devbox_bash!("rm -rf /tmp/test_project")
  end

  def test_installing
    devbox_bash "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    devbox_bash "cd /tmp/test_project && dev"

    assert_equal \
      devbox_bash("cd /tmp/test_project && which test_command"),
      "/var/devbox/test_project/dependencies/test_software_dependency/bin/test_command\n"

    output = devbox_bash("cd /tmp/test_project && test_command")
    assert_equal output, "test-command-output 1.2.3\n"
  end

  def test_not_installing_when_not_used_by_project
    devbox_bash "cd /tmp/test_project && dev"

    output = devbox_bash("cd /tmp/test_project && test_command")
    assert_include output, "command not found"
  end
end
