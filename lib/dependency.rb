class Dependency
  def environment_variables(previous_envs)
    previous_envs
  end

  def used_by_current_project?
    version
  end

  def cacheable?
    cacheable_path && cache_key
  end

  def cache_key
    "#{name}-#{version}"
  end

  def cacheable_path
    nil
  end

  def installed?
    raise "implement me"
  end

  def name
    raise "implement me"
  end

  def version
    "unversioned"
  end
end
