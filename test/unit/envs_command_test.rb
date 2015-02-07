class TestEnvsCommand < MTest::Unit::TestCase
  def test_setting_envs_from_dependency
    envs_at_login = {
      "FOO" => "set-at-login",
      "BAR" => "set-at-login",
    }

    dependency = FakeDependency.new
    command = EnvsCommand.new([ dependency ], envs_at_login)

    output = TestOutput.new
    command.run("envs", output)

    assert_include output.lines, 'export BAR="set-by-dependency"'
    assert_include output.lines, 'export FOO="set-at-login"'
  end

  def test_cleaning_out_unused_envs
    ENV["OTHER"] = "set-after-login"

    dependency = FakeDependency.new
    command = EnvsCommand.new([ dependency ], {})

    output = TestOutput.new
    command.run("envs", output)

    assert_include output.lines, 'unset OTHER'
  end

  def test_does_not_modify_the_original_hash
    envs_at_login = {
      "BAR" => "set-at-login",
    }

    dependency = FakeDependency.new
    command = EnvsCommand.new([ dependency ], envs_at_login)

    output = TestOutput.new
    command.run("envs", output)

    assert_equal envs_at_login["BAR"], "set-at-login"
  end

  class TestOutput
    def puts(line)
      lines.push(line)
    end

    def lines
      @lines ||= []
    end
  end

  class FakeDependency
    def environment_variables(previous_envs)
      previous_envs["BAR"] = "set-by-dependency"
      previous_envs
    end
  end
end
