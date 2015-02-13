require "envs_at_login"

class EnvironmentVariables
  READ_ONLY_ENVS = [ "_" ]

  def self.update
    file = File.open("/tmp/.envs_update", "w")
    build.write_to(file)
    file.close
  end

  def self.print
    build.write_to(STDOUT)
  end

  def self.build
    dependencies = DependencyRegistry.list
    envs_at_login = EnvsAtLogin.call
    new(dependencies, envs_at_login)
  end

  def initialize(dependencies, envs_at_login)
    @dependencies = dependencies
    @envs_at_login = envs_at_login
  end

  def options
    {
      "envs" => "Prints the project's environment variables"
    }
  end

  def write_to(output)
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

  attr_reader :dependencies, :envs_at_login
end
