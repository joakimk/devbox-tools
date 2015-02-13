class TestEnvironment < MTest::Unit::TestCase
  def test_dependency_setup_when_entering_project
    shell "mkdir -p /tmp/project1 /tmp/project2"
    dependency_path = "#{Devbox.software_dependencies_root}/test/bin"

    # enter directory it matches adds paths from dependencies
    envs = shell("cd /tmp/project1 && echo $PATH").split(":")
    assert_include envs, dependency_path
    assert_equal envs[0], dependency_path
    assert_equal envs[1], "#{Devbox.tools_root}/bin"

    # enter directory using zsh works too
    envs = zsh_shell("cd /tmp/project1 && echo $PATH").split(":")
    assert_include envs, dependency_path
    assert_equal envs[0], dependency_path
    assert_equal envs[1], "#{Devbox.tools_root}/bin"

    # entering another directory removes the paths
    envs = shell("cd /tmp/project1 && cd /tmp/project2 && echo $PATH").split(":")
    assert_not_include envs, dependency_path
    assert_include envs, "#{Devbox.tools_root}/bin"
  ensure
    shell "rm -rf /tmp/project1 && rm -rf /tmp/project2"
  end
end
