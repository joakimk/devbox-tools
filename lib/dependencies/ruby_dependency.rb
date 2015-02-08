# NOTE: This is only here until the dependency API is finished, then it's
#       supposed to be moved to a plugin. Represents regular software.

class RubyDependency < SoftwareDependency
  def name
    "ruby"
  end

  def status
    "no status yet"
  end

  def install
    # todo
  end

  def environment_variables(envs)
    envs = super(envs)
    envs["GEM_HOME"] = "#{Devbox.code_root}/gems"
    envs
  end

  private

  def version
    return nil unless Dir.pwd == "/tmp"
    "fake-detected-version"
  end
end

DependencyRegistry.register(RubyDependency.new)
