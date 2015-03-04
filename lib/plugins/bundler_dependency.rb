class BundlerDependency < SoftwareDependency
  def name
    "bundler"
  end

  def dependencies
    [ "ruby" ]
  end

  def used_by_current_project?
    super || File.exists?("Gemfile")
  end

  def remove
    ShellRunner.run("gem uninstall bundler --all --executables --force") && project_metadata.del("installed_version")
  end

  def build_and_install
    ShellRunner.run "gem install bundler -v #{version}"
    project_metadata.set("installed_version", version)
  end

  def installed?
    project_metadata.get("installed_version") == version
  end

  # Not cachable
  def cache_key
    nil
  end

  private

  def default_version
    "1.8.2"
  end
end
