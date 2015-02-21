class SystemSoftwareDependency < SoftwareDependency
  def used_by_current_project?
    # disabled in tests for now to make them simpler
    Devbox.environment != "test"
  end

  # Don't auto register an abstract class
  def self.autoregister?
    self != SystemSoftwareDependency
  end
end
