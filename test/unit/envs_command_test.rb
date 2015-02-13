class TestEnvsCommand < MTest::Unit::TestCase
  def test_setting_envs_from_used_dependencies
    envs_at_login = {
      "FOO" => "set-at-login",
      "BAR" => "set-at-login",
    }

    dependency = UsedDependency.new
    command = EnvsCommand.new([ dependency ], envs_at_login)

    output = TestOutput.new
    command.run("envs", [], output)

    assert_include output.lines, 'export BAR="set-by-dependency"'
    assert_include output.lines, 'export FOO="set-at-login"'
  end

  def test_cleaning_out_unused_envs_set_by_dependencies
    ENV["ENV_FROM_UNUSED_DEPENDENCY"] = "set-by-dependency"

    used_dependency = UsedDependency.new
    unused_dependency = UnusedDependency.new
    command = EnvsCommand.new([ used_dependency, unused_dependency ], {})

    output = TestOutput.new
    command.run("envs", [], output)

    assert_include output.lines, 'unset ENV_FROM_UNUSED_DEPENDENCY'
    assert_include output.lines, 'export ENV_FROM_USED_DEPENDENCY="set-by-dependency"'
  end

  def test_not_clearing_out_unknown_envs
    ENV["UNKNOWN_ENV"] = "set"

    used_dependency = UsedDependency.new
    unused_dependency = UnusedDependency.new
    command = EnvsCommand.new([ used_dependency, unused_dependency ], {})

    output = TestOutput.new
    command.run("envs", [], output)

    assert_not_include output.lines, 'unset UNKNOWN_ENV'
  end

  def test_does_not_clear_read_only_envs
    ENV["ENV_FROM_UNUSED_DEPENDENCY"] = "set-after-login"
    ENV["_"] = "set-after-login"

    used_dependency = UsedDependency.new
    unused_dependency = UnusedDependency.new
    command = EnvsCommand.new([ used_dependency, unused_dependency ], {})

    output = TestOutput.new
    command.run("envs", [], output)

    assert_include output.lines, 'unset ENV_FROM_UNUSED_DEPENDENCY'
    assert_not_include output.lines, 'unset _'
  end

  def test_does_not_modify_the_original_hash
    envs_at_login = {
      "BAR" => "set-at-login",
    }

    dependency = UsedDependency.new
    command = EnvsCommand.new([ dependency ], envs_at_login)

    output = TestOutput.new
    command.run("envs", [], output)

    assert_equal envs_at_login["BAR"], "set-at-login"
  end

  def test_does_not_set_read_only_envs
    envs_at_login = {
      "FOO" => "set-at-login",
      "_" => "set-at-login",
    }

    dependency = UsedDependency.new
    command = EnvsCommand.new([ dependency ], envs_at_login)

    output = TestOutput.new
    command.run("envs", [], output)

    assert_not_include output.lines, 'export _="set-at-login"'
    assert_include output.lines, 'export FOO="set-at-login"'
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
      previous_envs
    end
  end

  class UnusedDependency
    def used_by_current_project?
      false
    end

    def environment_variables(previous_envs)
      previous_envs["ENV_FROM_UNUSED_DEPENDENCY"] = "set-by-dependency"
      previous_envs["EDITOR"] = "set-by-dependency"
      previous_envs
    end
  end
end
