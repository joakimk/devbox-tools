class TestSoftwareDependency < SoftwareDependency
  def name
    "test_software_dependency"
  end

  def default_config
    super.merge({ something: "default", other: "more" })
  end

  def used_by_current_project?
    super || File.exists?("config/initializers/test_software_dependency.rb")
  end

  private

  def build_and_install
    test_command_path = "#{install_prefix}/bin/test_command"
    test_command_directory_path = File.dirname(test_command_path)

    Shell.run(%{
      mkdir -p #{test_command_directory_path}
      echo 'echo "test-command-output #{version}"' > #{test_command_path}
      chmod +x #{test_command_path}
    })
  end

  def required_packages
    [ "wget" ]
  end

  def default_version
    "1.0"
  end

  def autodetected_version
    path = "#{project_root}/.some_file_with_a_version"

    if File.exists?(path)
      File.read(path).chomp
    else
      nil
    end
  end
end
