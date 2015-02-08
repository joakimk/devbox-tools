class TestSoftwareDependencyManagement < MTest::Unit::TestCase
  def setup
    shell! "mkdir /tmp/test_project"
  end

  def teardown
    shell! "rm -rf /tmp/test_project && rm -rf /var/devbox/dependencies/test_software_dependency"
  end

  def test_installing
    shell "echo '1.2.3' > /tmp/test_project/.some_file_with_a_version"
    assert_include \
      shell("cd /tmp/test_project && test_command"),
      "command not found"
    shell "cd /tmp/test_project && dev"

    assert_equal \
      shell("cd /tmp/test_project && which test_command"),
      "/var/devbox/dependencies/test_software_dependency/bin/test_command\n"

    output = shell("cd /tmp/test_project && test_command")
    assert_equal output, "test-command-output 1.2.3\n"
  end

  def test_not_installing_when_not_used_by_project
    shell "cd /tmp/test_project && dev"

    output = shell("cd /tmp/test_project && test_command")
    assert_include output, "command not found"
  end
end
