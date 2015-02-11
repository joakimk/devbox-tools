class SystemSoftwareDependency < SoftwareDependency
  def used_by_current_project?
    !ENV["DEVBOX_TEST"]
  end
end
