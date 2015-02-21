# NOTE: This is only here until the dependency API is finished, then it's
#       supposed to be moved to a plugin. Represents regular software.

class RubyDependency < SoftwareDependency
  def name
    "ruby"
  end

  private

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

  def url
    major_version = version[0, 3]
    "http://cache.ruby-lang.org/pub/ruby/#{major_version}/#{archive_name}"
  end

  def expected_md5_and_filename
    manual_checksum = ENV["RUBY_CHECKSUM"]

    if manual_checksum
      "#{manual_checksum}  #{archive_name}"
    else
      content = exec_command("curl -s https://raw.githubusercontent.com/postmodern/ruby-versions/master/ruby/checksums.md5 | grep #{archive_name}").chomp

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

  def autodetected_version
    return nil unless Dir.pwd == "/tmp"
    "2.2.0" # TODO: actually detect version
  end
end
