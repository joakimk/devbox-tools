class PostgresDependency < ServiceDependency
  def name
    "postgres"
  end

  def used_by_current_project?
    super || rails_app_using_postgres?
  end

  private

  def required_packages
    # For compiling postgres clients and managing the DB
    # Probably not exactly the same version as the server, but it does
    # not seem to be a problem yet.
    #
    # If possible it would be nice to install the correct versions of each project.
    %w{ libpq-dev postgresql-client-common postgresql-client-9.3 }
  end

  def default_version
    "postgres:9.3"
  end

  def rails_app_using_postgres?
    File.exists?("config/database.yml") && File.read("config/database.yml").include?("adapter: postgresql")
  end
end
