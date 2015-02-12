# TODO: Move to plugin

class VimDependency < SystemSoftwareDependency
  def name
    "vim"
  end

  private

  def build_and_install_command
    %{
      wget ftp://ftp.vim.org/pub/vim/unix/vim-#{version}.tar.bz2
      tar xvfj vim-#{version}.tar.bz2
      echo "#{md5sum}  vim-#{version}.tar.bz2" | md5sum -c -
      cd vim73
      ./configure --prefix=#{install_prefix} --with-features=huge --enable-rubyinterp=yes
      make -j 2
      make install
    }
  end

  def required_packages
    %w{ build-essential libncurses5-dev ruby1.8-dev }
  end

  def version
    "7.3"
  end

  def md5sum
    "5b9510a17074e2b37d8bb38ae09edbf2"
  end
end

DependencyRegistry.register(VimDependency.new)
