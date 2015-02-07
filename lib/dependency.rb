class Dependency
  def install
    # no-op
  end

  def start
    # no-op
  end

  def environment_variables(previous_envs)
    previous_envs
  end

  def used_by_project?(directory)
    raise "Not implemented"
  end
end
