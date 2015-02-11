class SystemSoftwareDependency < SoftwareDependency
  def used_by_current_project?
    true
  end
end
