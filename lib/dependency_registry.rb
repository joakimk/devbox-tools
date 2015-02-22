require "dependency_lookup"

# TODO: make most the methods instance methods to get private scoping, etc.
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
    load_regular_dependencies
    load_generic_services
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

  private

  def self.load_regular_dependencies
    @classes.each do |dependency_class|
      register(dependency_class.new) if dependency_class.autoregister?
    end
  end

  def self.load_generic_services
    config = Config.load
    config.fetch(:dependencies, []).each do |name, options|
      next unless options[:service]
      next if registered?(name)

      dependency = GenericServiceDependency.new(name.to_s)
      DependencyRegistry.register(dependency)
    end
  end

  def self.registered?(name)
    list.map(&:name).include?(name.to_s)
  end
end
