require "envs_at_login"

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
    all_names_for_envs_that_can_be_set_by_this_tool.each do |name|
      output.puts "unset #{name}"
    end

    envs_to_set.each do |name, value|
      output.puts "export #{name}=#{value.inspect}"
    end
  end

  private

  def envs_to_set
    envs = default_envs.merge(envs_at_login.dup)

    envs["PATH"] = paths_excluding_any_dependencies

    project_dependencies.each do |dependency|
      envs = dependency.environment_variables(envs.dup)
    end

    except_read_only_envs(envs)
  end

  def paths_excluding_any_dependencies
    current_paths = ENV["PATH"].to_s.split(":")
    current_paths.
      reject { |path| path.include?(Devbox.software_dependencies_root) }.
      join(":")
  end

  def all_names_for_envs_that_can_be_set_by_this_tool
    dependencies.flat_map { |dependency|
      dependency.environment_variables(default_envs).keys
    }.uniq
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
