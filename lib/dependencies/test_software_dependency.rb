class TestSoftwareDependency < SoftwareDependency
  def name
    "test_software_dependency"
  end

  def status
    "no status yet"
  end

  def install
    super
    test_command_path = "#{install_prefix}/bin/test_command"
    test_command_directory_path = File.dirname(test_command_path)

    system(%{
      mkdir -p #{test_command_directory_path} &&
      echo 'echo "test-command-output #{version}"' > #{test_command_path} &&
      chmod +x #{test_command_path}
    })
  end

  private

  def required_packages
    [ "wget" ]
  end

  def version
    path = "#{project_root}/.some_file_with_a_version"

    if File.exists?(path)
      File.read(path).chomp
    else
      nil
    end
  end
end

DependencyRegistry.register(TestSoftwareDependency.new)
