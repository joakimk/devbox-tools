class EnvironmentVariablesTest < MTest::Unit::TestCase
  test "setting envs from used dependencies" do
    envs_at_login = {
      "BAR" => "set-at-login",
    }

    dependency = UsedDependency.new
    envs = EnvironmentVariables.new([ dependency ], envs_at_login)

    output = TestOutput.new
    envs.write_to(output)

    assert_include output.lines, 'export BAR="set-by-dependency"'
  end

  test "cleaning out unused envs set by dependencies" do
    ENV["ENV_FROM_UNUSED_DEPENDENCY"] = "set-by-dependency"

    used_dependency = UsedDependency.new
    unused_dependency = UnusedDependency.new
    envs = EnvironmentVariables.new([ used_dependency, unused_dependency ], {})

    output = TestOutput.new
    envs.write_to(output)

    assert output.lines.join.include?("export ENV_FROM_USED_DEPENDENCY")
    assert !output.lines.join.include?("export ENV_FROM_UNUSED_DEPENDENCY")
    assert_include output.lines, 'unset ENV_FROM_UNUSED_DEPENDENCY'
    assert_include output.lines, 'export ENV_FROM_USED_DEPENDENCY="set-by-dependency"'
  end

  test "ignoring unknown envs" do
    envs_at_login = {
      "FOO" => "set-at-login",
      "BAR" => "set-at-login",
    }

    dependency = UsedDependency.new
    envs = EnvironmentVariables.new([ dependency ], envs_at_login)

    output = TestOutput.new
    envs.write_to(output)

    assert_include output.lines, 'export BAR="set-by-dependency"'
    assert output.lines.join.include?("BAR")
    assert !output.lines.join.include?("FOO")
  end

  test "does not modify the original hash" do
    envs_at_login = {
      "BAR" => "set-at-login",
    }

    dependency = UsedDependency.new
    envs = EnvironmentVariables.new([ dependency ], envs_at_login)

    output = TestOutput.new
    envs.write_to(output)

    assert_equal envs_at_login["BAR"], "set-at-login"
  end

  test "keeps changes to path that we did not make" do
    # set by user after login, and what remains of previous paths
    ENV["PATH"] = "/bin:/usr/bin:/custom/bin:#{Devbox.software_dependencies_root}/unused/bin"

    envs_at_login = {
      "PATH" => "/bin:/usr/bin"
    }

    used_dependency = UsedDependency.new
    unused_dependency = UnusedDependency.new
    envs = EnvironmentVariables.new([ used_dependency, unused_dependency ], envs_at_login)

    output = TestOutput.new
    envs.write_to(output)

    assert_include output.lines, %{export PATH="#{Devbox.software_dependencies_root}/used/bin:/bin:/usr/bin:/custom/bin"}
  end

  class TestOutput
    def puts(line)
      lines.push(line)
    end

    def lines
      @lines ||= []
    end
  end

  class UsedDependency
    def used_by_current_project?
      true
    end

    def environment_variables(previous_envs)
      previous_envs["ENV_FROM_USED_DEPENDENCY"] = "set-by-dependency"
      previous_envs["BAR"] = "set-by-dependency"
      previous_envs["PATH"] = "#{Devbox.software_dependencies_root}/used/bin:" + previous_envs["PATH"]
      previous_envs
    end
  end

  class UnusedDependency
    def used_by_current_project?
      false
    end

    def environment_variables(previous_envs)
      previous_envs["ENV_FROM_UNUSED_DEPENDENCY"] = "set-by-dependency"
      previous_envs["PATH"] = "#{Devbox.software_dependencies_root}/unused/bin:" + previous_envs["PATH"]
      previous_envs
    end
  end
end
