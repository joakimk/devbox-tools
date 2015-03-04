class RubyDependency < SoftwareDependency
  require "#{File.dirname(__FILE__)}/ruby_dependency/version"

  def name
    "ruby"
  end

  def used_by_current_project?
    super || ruby_project?
  end

  def environment_variables(envs)
    envs = super(envs)
    envs["GEM_HOME"] = "#{Devbox.project_data_root}/gems"
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

  def ruby_project?
    File.exists?("Gemfile")
  end

  def build_and_install_command
    %{
      wget #{url}

      echo "#{expected_md5_and_filename}" | md5sum -c -

      tar xfz #{archive_name}
      cd ruby-#{version}
      autoconf

      ./configure --prefix=#{install_prefix}

      make -j 2
      make install
    }
  end

  def url
    major_version = version[0, 3]
    "http://cache.ruby-lang.org/pub/ruby/#{major_version}/#{archive_name}"
  end

  def expected_md5_and_filename
    manual_checksum = ENV["RUBY_CHECKSUM"]

    if manual_checksum
      "#{manual_checksum}  #{archive_name}"
    else
      content = `curl -s https://raw.githubusercontent.com/postmodern/ruby-versions/master/ruby/checksums.md5 | grep #{archive_name}`.chomp

      unless content.include?(archive_name)
        raise <<-STR

Could not find a checksum for #{archive_name}. The checksum is needed to verify that the downloaded ruby version is the offical version.

You can set the checksum you find on https://www.ruby-lang.org/en/downloads/ using RUBY_CHECKSUM=\"md5-hash\".
        STR
      end

      content
    end
  end

  def archive_name
    "ruby-#{version}.tar.gz"
  end

  def required_packages
    %w{
      build-essential wget curl build-essential autoconf bison libyaml-dev libffi-dev zlib1g-dev libxml2-dev libxslt-dev libreadline-dev libsqlite3-dev libcurl4-openssl-dev
    }
  end

  def default_version
    "2.2.0"
  end

  def autodetected_version
    RubyDependency::Version.detect
  end
end
