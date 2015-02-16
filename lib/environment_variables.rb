require "envs_at_login"
require "environment_variables_update"

class EnvironmentVariables
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

  def write_to(output)
    all_names_for_envs_that_can_be_set_by_this_tool.each do |name|
      write_env_unset(output, name)
      write_env_export(output, name)
    end
  end

  private

  def write_env_unset(output, name)
    output.puts "unset #{name}"
  end

  def write_env_export(output, name)
    value = updated_envs[name]

    if value
      output.puts "export #{name}=#{value.inspect}"
    end
  end

  def updated_envs
    EnvironmentVariablesUpdate.new(dependencies, envs_at_login).generate
  end

  def all_names_for_envs_that_can_be_set_by_this_tool
    dependencies.flat_map { |dependency|
      dependency.environment_variables(default_envs).keys
    }.uniq
  end

  # Don't break basic assumptions in environment_variables methods.
  def default_envs
    {
      "PATH" => ""
    }
  end

  attr_reader :dependencies, :envs_at_login
end
