# NOTE: This is only here until the dependency API is finished, then it's
#       supposed to be moved to a plugin. Represents regular software.

class RubyDependency < SoftwareDependency
  def name
    "ruby"
  end

  def build_and_install
    run_build do
      %{
        wget #{url}
        tar xfz ruby-#{version}.tar.gz
        cd ruby-#{version}
        autoconf

        ./configure --prefix=#{install_prefix}

        make -j 2
        make install
      }
    end
  end

  def environment_variables(envs)
    envs = super(envs)
    envs["GEM_HOME"] = "#{Devbox.project_code_root}/gems"
    envs["GEM_PATH"] = envs["GEM_HOME"]
    envs["PATH"] = "#{envs["GEM_HOME"]}/bin:#{envs["PATH"]}"

    # We only know the gem_directory if the ruby version is installed, so the first cd into
    # a directory won't have GEM_PATH, but after you run "dev" to install ruby,
    # it will be added.
    gem_directory = Finder.files("lib/ruby/gems", install_prefix)[0]

    if gem_directory
      envs["GEM_PATH"] += ":#{gem_directory}"
    end

    envs
  end

  private

  def url
    # TODO: How to handle checksum security? homebrew handles it by having you set a checksum as well as a version,
    # but what to do if the version is autodetected? A local list of known checksums is no good for new versions, etc.
    major_version = version[0, 3]
    "http://cache.ruby-lang.org/pub/ruby/#{major_version}/ruby-#{version}.tar.gz"
  end

  def required_packages
    %w{
      build-essential wget curl build-essential autoconf bison libyaml-dev libffi-dev zlib1g-dev libxml2-dev libxslt-dev libreadline-dev libsqlite3-dev libcurl4-openssl-dev
    }
  end

  def version
    return nil unless Dir.pwd == "/tmp"
    "2.2.0" # TODO: actually detect version
  end
end

DependencyRegistry.register(RubyDependency.new)
