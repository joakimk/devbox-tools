require "envs_at_login"

# This command clears out any ENVs set that is no longer used,
# updates envs that have changed and sets new envs.
#
# It does so by printing shell commands which we source in
# support/shell.

class EnvsCommand < Command
  READ_ONLY_ENVS = [ "_" ]

  def initialize(dependencies, envs_at_login)
    @dependencies = dependencies
    @envs_at_login = envs_at_login
  end

  def options
    {
      "envs" => "Prints the project's environment variables"
    }
  end

  def run(_option, _parameters, output = STDOUT)
    except_read_only_envs(envs_that_can_be_set_by_this_tool).each do |name, _|
      output.puts "unset #{name}"
    end

    except_read_only_envs(envs_to_set).each do |name, value|
      output.puts "export #{name}=#{value.inspect}"
    end
  end

  private

  def envs_that_can_be_set_by_this_tool
    dependencies.flat_map { |dependency|
      dependency.environment_variables(default_envs).keys
    }
  end

  def envs_to_set
    envs = envs_at_login.dup

    project_dependencies.each do |dependency|
      envs = dependency.environment_variables(envs.dup)
    end

    envs
  end

  def except_read_only_envs(envs)
    envs.reject { |k, v| READ_ONLY_ENVS.include?(k) }
  end

  def project_dependencies
    dependencies.select(&:used_by_current_project?)
  end

  # Don't break basic assumptions in environment_variables methods.
  def default_envs
    {
      "PATH" => ""
    }
  end

  # The DependencyRegistry must be queried at runtime and not at load time so that
  # all dependencies has a chance to load.
  def dependencies
    @dependencies ||= DependencyRegistry.list
  end

  attr_reader :envs_at_login
end

envs_at_login = EnvsAtLogin.call
command = EnvsCommand.new(nil, envs_at_login)
CommandDispatcher.register(command)
