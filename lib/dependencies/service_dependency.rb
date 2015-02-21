require "docker_metadata"

class ServiceDependency < Dependency
  def initialize(name, options)
    @name, @options = name, options
  end

  attr_reader :name

  def install(logger)
    logger.detail "Pulling docker image..."
    docker "pull #{docker_image}"
    devbox_metadata.set("installed", true)
  end

  def status
    # A generic ServiceDependency is always configured. Plugins for
    # specific services can do autodetection or use defaults.
    "#{docker_image_version} installed (configured)"
  end

  def installed?
    devbox_metadata.get("installed")
  end

  def start(logger)
    return if running?

    logger.detail "Starting #{display_name}"
    remove_previous_container
    volume_mounts = docker_metadata.volumes.map { |path| "-v #{data_root}/#{path}:#{path}" }
    docker "run --detach --name #{docker_name} --publish #{docker_metadata.internal_port} #{volume_mounts.join(" ")} #{docker_image}"
    devbox_metadata.set("external_port", docker_metadata.external_port)
  end

  def stop(logger)
    return unless running?

    logger.detail "Stopping #{display_name}"
    docker "stop #{docker_name}"
  end

  def used_by_current_project?
    # All ServiceDependency are used by the current project because they are only
    # instantiated if they are configured to be used within the current project.
    true
  end

  private

  def environment_variables(envs)
    envs["#{name.upcase}_PORT"] = devbox_metadata.get("external_port")
    envs
  end

  def devbox_metadata
    Metadata.new(name)
  end

  def docker_metadata
    DockerMetadata.new(docker_name, docker_image)
  end

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

  def data_root
    File.join(Devbox.project_data_root, "services", name)
  end

  # Don't auto register since this class has custom instatiation. See below.
  def self.autoregister?
    false
  end

  attr_reader :options
end

config = Config.load
config.fetch(:services, []).each do |name, options|
  dependency = ServiceDependency.new(name.to_s, options)
  DependencyRegistry.register(dependency)
end
