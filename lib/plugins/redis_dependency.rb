class RedisDependency < ServiceDependency
  def name
    "redis"
  end

  def used_by_current_project?
    super || rails_app_using_redis?
  end

  private

  def default_version
    "redis:2.8"
  end

  def rails_app_using_redis?
    File.exists?("config/initializers/redis.rb")
  end
end
