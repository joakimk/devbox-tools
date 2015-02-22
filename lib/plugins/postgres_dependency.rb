class PostgresDependency < ServiceDependency
  def name
    "postgres"
  end

  def used_by_current_project?
    super || rails_app_using_postgres?
  end

  private

  def default_version
    "postgres:9.3"
  end

  def rails_app_using_postgres?
    File.exists?("config/database.yml") && File.read("config/database.yml").include?("adapter: postgresql")
  end
end
