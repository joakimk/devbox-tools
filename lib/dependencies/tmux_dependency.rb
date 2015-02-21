# TODO: Move to plugin

class TmuxDependency < SystemSoftwareDependency
  def name
    "tmux"
  end

  private

  def build_and_install_command
    %{
      wget http://iweb.dl.sourceforge.net/project/tmux/tmux/tmux-#{version[0, 3]}/tmux-#{version}.tar.gz
      tar xfz tmux-#{version}.tar.gz
      echo "#{sha1sum}  tmux-#{version}.tar.gz" | sha1sum -c -
      cd tmux-#{version}
      ./configure --prefix=#{install_prefix}
      make -j 2
      make install
    }
  end

  def required_packages
    %w{ build-essential libevent-dev libncurses5-dev }
  end

  def default_version
    "1.9a"
  end

  def sha1sum
    config.fetch(:sha1sum, "815264268e63c6c85fe8784e06a840883fcfc6a2")
  end
end
