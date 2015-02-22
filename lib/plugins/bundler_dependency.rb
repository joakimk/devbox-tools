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
    Shell.run("gem uninstall bundler --all --executables --force") && metadata.del("installed_version")
  end

  def build_and_install
    Shell.run "gem install bundler -v #{version}"
    metadata.set("installed_version", version)
  end

  def installed?
    metadata.get("installed_version") == version
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
