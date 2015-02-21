class TestDependency < Dependency
  def name
    "test"
  end

  def environment_variables(envs)
    envs["PATH"] = "#{Devbox.software_dependencies_root}/test/bin:" + envs["PATH"]
    envs
  end

  def used_by_current_project?
    Devbox.project_root.end_with?("project1")
  end
end
