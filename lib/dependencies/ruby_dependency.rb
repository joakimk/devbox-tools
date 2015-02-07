# NOTE: This is only here until the dependency API is finished, then it's
#       supposed to be moved to a plugin.

class RubyDependency < Dependency
  def environment_variables(previous_envs)
    out = previous_envs.dup
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
