require "dependency_lookup"

class DependencyRegistry
  # Registers dependencies when inheriting from Dependency.
  #
  # We load them later when they are finished loading, otherwise
  # the classes don't have time to define "autoregister?"
  def self.register_class(dependency_class)
    @classes ||= []
    @classes.push(dependency_class)
  end

  def self.load
    @classes.each do |dependency_class|
      register(dependency_class.new) if dependency_class.autoregister?
    end
  end

  def self.register(dependency)
    Devbox.logger.debug __FILE__, "Adding dependency: #{dependency.name}"
    list.push(dependency)
  end

  def self.dependencies_used_by_the_current_project
    DependencyLookup.new(list).used_by_current_project
  end

  def self.list
    @list ||= []
  end
end
