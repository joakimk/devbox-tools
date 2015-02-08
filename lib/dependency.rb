class Dependency
  def environment_variables(previous_envs)
    previous_envs
  end

  def used_by_current_project?
    version
  end
end
