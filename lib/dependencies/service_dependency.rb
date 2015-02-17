class ServiceDependency < Dependency
  def initialize(name, options)
    @name, @options = name, options
  end

  attr_reader :name

  def install(logger)
    logger.detail "Pulling docker image..."
    docker "pull #{docker_image}"
  end

  def status
    # A generic ServiceDependency is always configured. Plugins for
    # specific services can do autodetection or use defaults.
    "#{docker_image_version} installed (configured)"
  end

  def installed?
    docker("images #{docker_image_name} | grep #{docker_image_version}", may_fail: true)
  end

  def start(logger)
    return if running?

    logger.detail "Starting #{name}"
    remove_previous_container
    docker "run --detach --name #{docker_name} #{docker_image}"
  end

  def stop(logger)
    logger.detail "Stopping #{name}"
    docker "stop #{docker_name}"
  end

  def used_by_current_project?
    # All ServiceDependency are used by the current project because they are only
    # instantiated if they are configured to be used within the current project.
    true
  end

  private

  # If any of the options changes, we want to register that under "docker_name"
  # instead of the previous options.
  def remove_previous_container
    return unless container_exists?
    docker "rm #{docker_name}"
  end

  def running?
    docker "ps | grep #{docker_name}", may_fail: true
  end

  def container_exists?
    docker "ps -a | grep #{docker_name}", may_fail: true
  end

  def docker(command, options = {})
    Shell.run("sudo docker #{command}", options)
  end

  def docker_image_name
    docker_image.split(":").first
  end

  def docker_image_version
    docker_image.split(":").last
  end

  def docker_image
    options.fetch(:image)
  end

  def docker_name
    [ Devbox.local_project_identifier, name ].join("-")
  end

  attr_reader :options
end

config = Config.load
config.fetch(:services, []).each do |name, options|
  dependency = ServiceDependency.new(name, options)
  DependencyRegistry.register(dependency)
end
