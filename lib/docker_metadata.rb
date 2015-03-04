require "json"

class DockerMetadata
  def initialize(name, image_name)
    @name, @image_name = name, image_name
  end

  def internal_port
    data["Config"]["ExposedPorts"].keys.first.split("/").first
  end

  def external_port
    str = `sudo docker port #{name}`
    str.include?("tcp") ? str.split(":").last.chomp : nil
  end

  def volumes
    data["Config"]["Volumes"].keys
  end

  private

  attr_reader :name, :image_name

  def data
    @data ||= begin
      json = `sudo docker inspect #{image_name}`
      data = JSON.parse(json)

      # They wrap the data in an array, probably so that you can query for more than one thing
      # at a time.
      data.first
    end
  end
end
