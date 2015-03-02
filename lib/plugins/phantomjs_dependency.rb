class PhantomjsDependency < SoftwareDependency
  def name
    "phantomjs"
  end

  private

  def required_packages
    %w{ libqt4-dev xvfb }
  end

  def build_and_install_command
    %{
      wget #{url}
      echo "#{checksum}  #{archive_name}" | sha1sum -c -
      tar xfj #{archive_name}
      mv phantomjs-#{version}-linux-x86_64 #{install_prefix}
    }
  end

  def archive_name
    "phantomjs-#{version}-linux-x86_64.tar.bz2"
  end

  def url
    "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-#{version}-linux-x86_64.tar.bz2"
  end
end
