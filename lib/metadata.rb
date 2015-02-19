# Stores information about dependencies. Usually used for caching
# to avoid having to run expensive lookups more than nessesary
#
# We need it to be fast so that running "dev" when nothing needs to be done
# or cd'ing to a directory remains fast (~sub 200ms).

class Metadata
  def initialize(dependency_name)
    @dependency_name = dependency_name
  end

  def set(name, value)
    path = build_path(name)
    File.write(path, value)
  end

  def get(name)
    path = build_path(name)
    File.exists?(path) && File.read(path).chomp
  end

  private

  def build_path(name)
    File.join(Devbox.metadata_path, "#{dependency_name}_#{name}")
  end

  attr_reader :dependency_name
end
