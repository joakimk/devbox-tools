class EnvironmentVariablesUpdate
  def initialize(dependencies, envs_at_login)
    @dependencies = dependencies
    @envs_at_login = envs_at_login
  end

  def generate
    envs = envs_at_login.dup
    envs = apply_custom_paths_added_since_login(envs)
    apply_current_environment(envs)
  end

  private

  def apply_custom_paths_added_since_login(envs)
    envs["PATH"] = current_paths_excluding_any_dependency_paths
    envs
  end

  def apply_current_environment(envs)
    project_dependencies.each do |dependency|
      envs = dependency.environment_variables(envs.dup)
    end

    envs
  end

  attr_reader :envs_at_login, :dependencies

  def current_paths_excluding_any_dependency_paths
    current_paths = ENV["PATH"].to_s.split(":")
    current_paths.
      reject { |path| path.include?(Devbox.software_dependencies_root) }.
      join(":")
  end

  def project_dependencies
    dependencies.select(&:used_by_current_project?)
  end
end
