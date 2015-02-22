class NodejsDependency < SoftwareDependency
  def name
    "node"
  end

  def display_name
    "node.js"
  end

  def used_by_current_project?
    super || rails_project_using_javascript_assets?
  end

  private

  def rails_project_using_javascript_assets?
    File.exists?("Gemfile") && File.read("Gemfile").include?("jquery")
  end

  def required_packages
    %w{ build-essential libssl-dev apache2-utils }
  end

  def build_and_install_command
    %{
      wget http://nodejs.org/dist/v#{version}/#{archive_name}
      tar xfz #{archive_name}
      echo "#{checksum}  #{archive_name}" | sha256sum -c -
      cd node-v#{version}
      ./configure --prefix=#{install_prefix}
      make -j 2
      make install
    }
  end

  def default_version
    "0.12.0"
  end

  def archive_name
    "node-v#{version}.tar.gz"
  end

  def checksum
    super || "9700e23af4e9b3643af48cef5f2ad20a1331ff531a12154eef2bfb0bb1682e32"
  end
end
