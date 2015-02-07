# NOTE: This is only here until the dependency API is finished, then it's
#       supposed to be moved to a plugin. Represents services using docker.

class RedisDependency < Dependency
  DEFAULT_REDIS_IMAGE = "redis:2.8"

  def name
    "redis"
  end

  def status
    "no status yet (#{version})"
  end

  def install
    system("sudo docker pull #{image}")
  end

  def environment_variables(envs)
    #envs["REDIS_PORT"] =
    envs["REDIS_URL"] = "redis://..."
    envs
  end

  def used_by_project?(directory)
    image
  end

  private

  def image
    return nil if Dir.pwd == "/"
    DEFAULT_REDIS_IMAGE

    # TODO:
    # if in config
    #   use config image
    # else if the project needs redis
    #   DEFAULT_REDIS_IMAGE
    # else
    #   nil
  end
end

DependencyRegistry.register(RedisDependency.new)