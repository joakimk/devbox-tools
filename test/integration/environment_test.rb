class TestEnvironment < MTest::Unit::TestCase
  def test_dependency_setup_when_entering_project
    shell "mkdir -p /vagrant/plugins/test/dependencies /tmp/project1 /tmp/project2"

    # add dependency plugin
    File.open("/vagrant/plugins/test/test_dependency.rb", "w") do |f|
      f.puts(%{
        class TestDependency
          def environment_variables(envs)
            envs["PATH"] = "/foo/bar/bin:" + envs["PATH"]
            envs
          end

          def used_by_current_project?
            Devbox.project_root.end_with?("project1")
          end
        end

        DependencyRegistry.register(TestDependency.new)
      })
    end

    # enter directory it matches adds paths from dependencies
    envs = shell("cd /tmp/project1 && echo $PATH").split(":")
    assert_include envs, "/foo/bar/bin"
    assert_equal envs[0], "/foo/bar/bin"
    assert_equal envs[1], "/vagrant/devbox-tools/bin"

    # enter directory using zsh works too
    envs = zsh_shell("cd /tmp/project1 && echo $PATH").split(":")
    assert_include envs, "/foo/bar/bin"
    assert_equal envs[0], "/foo/bar/bin"
    assert_equal envs[1], "/vagrant/devbox-tools/bin"

    # entering another directory removes the paths
    envs = shell("cd /tmp/project1 && cd /tmp/project2 && echo $PATH").split(":")
    assert_not_include envs, "/foo/bar/bin"
    assert_equal envs[0], "/vagrant/devbox-tools/bin"
  ensure
    shell "rm -rf /vagrant/plugins/test && rm -rf /tmp/project1 && rm -rf /tmp/project2"
  end
end
