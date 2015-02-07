# NOTE: This is only here until the dependency API is finished, then it's
#       supposed to be moved to a plugin. Represents regular software.

class RubyDependency < Dependency
  def name
    "ruby"
  end

  def status
    "no status yet"
  end

  def install
    # todo
  end

  def environment_variables(previous_envs)
    out = previous_envs
    out["GEM_HOME"] = "#{Devbox.code_root}/gems"
    out
  end

  def used_by_project?(directory)
    ruby_version
  end

  private

  def ruby_version
    return nil if Dir.pwd == "/"
    "fake-detected-version"
  end
end

DependencyRegistry.register(RubyDependency.new)