class PostgresDependency < ServiceDependency
  def name
    "postgres"
  end

  def used_by_current_project?
    super || rails_app_using_postgres?
  end

  private

  def required_packages
    # For compiling postgres clients
    # Probably not exactly the same version as the server, but that does
    # not seem to make much of a difference.
    %w{ libpq-dev }
  end

  def default_version
    "postgres:9.3"
  end

  def rails_app_using_postgres?
    File.exists?("config/database.yml") && File.read("config/database.yml").include?("adapter: postgresql")
  end
end
