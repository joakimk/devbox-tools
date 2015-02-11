require "dependency"
require "software_dependency"
require "system_software_dependency"

class DependencyRegistry
  def self.register(dependency)
    list.push(dependency)
  end

  def self.dependencies_used_by_the_current_project
    list.select(&:used_by_current_project?)
  end

  def self.list
    @list ||= []
  end
end
