class GitDependency < SystemSoftwareDependency
  def name
    "git"
  end

  private

  def required_packages
    %w{ build-essential zlib1g-dev gettext libcurl4-openssl-dev }
  end

  def build_and_install_command
    %{
      set -e
      cd /tmp
      wget https://www.kernel.org/pub/software/scm/git/git-#{version}.tar.gz
      tar xfz git-#{version}.tar.gz
      cd git-#{version}
      ./configure --prefix=#{install_prefix}
      make -j 2
      make install
    }
  end

  def default_version
    # latest stable when this was made, can probably be updated
    "2.3.0"
  end
end
