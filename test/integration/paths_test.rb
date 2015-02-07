class TestPaths < MTest::Unit::TestCase
  def test_devbox_path
    assert_include devbox_bash("echo $PATH"), "/vagrant/devbox-tools/bin"
  end

  def test_dependency_setup_when_entering_project
    devbox_bash "mkdir -p /vagrant/plugins/test/dependencies /tmp/project1 /tmp/project2"

    # add dependency plugin
    File.open("/vagrant/plugins/test/dependencies/test_dependency.rb", "w") do |f|
      f.puts(%{
        class TestDependency
          def environment_variables(previous_envs)
            out = previous_envs
            out["PATH"] = "/foo/bar/bin:" + previous_envs["PATH"]
            out
          end

          def used_by_project?(directory)
            directory.end_with?("project1")
          end
        end

        DependencyRegistry.register(TestDependency.new)
      })
    end

    # enter directory it matches adds paths from dependencies
    envs = devbox_bash("cd /tmp/project1 && echo $PATH").split(":")
    assert_include envs, "/foo/bar/bin"
    assert_equal envs[0], "/foo/bar/bin"
    assert_equal envs[1], "/vagrant/devbox-tools/bin"

    # entering another directory removes the paths
    envs = devbox_bash("cd /tmp/project1 && cd /tmp/project2 && echo $PATH").split(":")
    assert_not_include envs, "/foo/bar/bin"
    assert_equal envs[0], "/vagrant/devbox-tools/bin"
  ensure
    devbox_bash "rm -rf /vagrant/plugins/test && rm -rf /tmp/project1 && rm -rf /tmp/project2"
  end

  # todo:
  #def test_entering_project_when_using_zsh
end
