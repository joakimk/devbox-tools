require "docker_metadata"

class ServiceDependency < Dependency
  # Don't auto register since this class is abstract.
  def self.autoregister?
    self != ServiceDependency
  end

  def install(logger)
    logger.detail "Pulling docker image..."
    docker "pull #{docker_image}"
    shared_metadata.set("installed", true)
  end

  def installed?
    shared_metadata.get("installed")
  end

  def start(logger)
    return if running?

    logger.detail "Starting #{display_name}"
    remove_previous_container
    volume_mounts = docker_metadata.volumes.map { |path| "-v #{data_root}/#{path}:#{path}" }
    docker "run --detach --name #{docker_name} --publish #{docker_metadata.internal_port} #{volume_mounts.join(" ")} #{docker_image}"
    project_metadata.set("external_port", docker_metadata.external_port)
  end

  def stop(logger)
    return unless running?

    logger.detail "Stopping #{display_name}"
    docker "stop #{docker_name}"
  end

  private

  def display_version
    docker_image_version
  end

  def environment_variables(envs)
    envs["#{name.upcase}_PORT"] = project_metadata.get("external_port")
    envs
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
    version
  end

  def docker_name
    [ Devbox.local_project_identifier, name ].join("-")
  end

  def data_root
    File.join(Devbox.project_data_root, "services", name)
  end
end
