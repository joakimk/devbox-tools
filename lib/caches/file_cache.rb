class FileCache
  def initialize(dependency, archive_directory_path)
    @dependency = dependency
    @archive_directory_path = archive_directory_path
  end

  def exists?
    File.exists?(archive_path)
  end

  def restore
    Shell.run("mkdir -p #{cacheable_parent_directory_path} && cd #{cacheable_parent_directory_path} && tar xfz #{archive_path}")
  end

  def build
    Shell.run("mkdir -p #{archive_directory_path} && cd #{cacheable_parent_directory_path} && tar cfz #{archive_path} #{cacheable_directory_name}")
  end

  private

  def archive_path
    [ archive_directory_path, "/", dependency.cache_key, ".tar.gz" ].join
  end

  def cacheable_directory_name
    File.basename(cacheable_path)
  end

  def cacheable_parent_directory_path
    File.expand_path(File.dirname(cacheable_path))
  end

  def cache_key
    dependency.cache_key
  end

  def cacheable_path
    dependency.cacheable_path
  end

  attr_reader :dependency, :archive_directory_path
end
