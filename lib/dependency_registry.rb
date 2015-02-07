require "dependency"

class DependencyRegistry
  def self.register(dependency)
    list.push(dependency)
  end

  def self.dependencies_used_by_the_current_project
    list.select { |dependency| dependency.used_by_project?(Devbox.project_root) }
  end

  def self.list
    @list ||= []
  end
end
