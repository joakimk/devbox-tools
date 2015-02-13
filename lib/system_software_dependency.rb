class SystemSoftwareDependency < SoftwareDependency
  def used_by_current_project?
    # disabled in tests for now to make them simpler
    Devbox.environment != "test"
  end
end
