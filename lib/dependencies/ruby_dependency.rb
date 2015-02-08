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
    super
  end

  def environment_variables(envs)
    envs = super(envs)
    envs["GEM_HOME"] = "#{Devbox.project_code_root}/gems"
    envs
  end

  private

  def required_packages
    %w{ build-essential wget curl build-essential autoconf bison libyaml-dev libffi-dev zlib1g-dev libxml2-dev libxslt-dev libreadline-dev libsqlite3-dev libcurl4-openssl-dev }
  end

  def version
    return nil unless Dir.pwd == "/tmp"
    "fake-detected-version"
  end
end

DependencyRegistry.register(RubyDependency.new)
