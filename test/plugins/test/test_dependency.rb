class TestDependency
  def environment_variables(envs)
    envs["PATH"] = "/foo/bar/bin:" + envs["PATH"]
    envs
  end

  def used_by_current_project?
    Devbox.project_root.end_with?("project1")
  end
end

DependencyRegistry.register(TestDependency.new)
