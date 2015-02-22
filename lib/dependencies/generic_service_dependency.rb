class GenericServiceDependency < ServiceDependency
  # Don't auto register since this class. It's registered in DependencyRegistry.load if needed.
  def self.autoregister?
    false
  end

  def initialize(name)
    @name = name
  end

  attr_reader :name
end
