class TestServiceDependency < ServiceDependency
  def name
    "test_service"
  end

  def used_by_current_project?
    super || project_using_redis?
  end

  private

  def default_version
    "redis:2.8"
  end

  def project_using_redis?
    File.exists?("config/initializers/redis.rb")
  end
end
