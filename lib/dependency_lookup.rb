# Returns a list of dependencies used by the current project ordered so
# that dependencies of dependencies come first.
#
# E.g. install ruby before bundler.

class DependencyLookup
  def initialize(list)
    @list = list
  end

  def used_by_current_project
    dependencies_of_other_dependencies =
      names_of_dependencies_of_other_dependencies.
      map { |name| raise_if_missing(find_dependency(name), name) }

    (dependencies_of_other_dependencies + dependencies_used_by_project).uniq
  end

  private

  def find_dependency(name)
    dependencies_used_by_project.find { |d| d.name == name }
  end

  def raise_if_missing(dependency, name)
    return dependency if dependency

    raise "project dependencies depend on \"#{name}\" but there is no such dependency loaded"
  end

  def names_of_dependencies_of_other_dependencies
    dependencies_used_by_project.flat_map(&:dependencies)
  end

  def dependencies_used_by_project
    @list.select(&:used_by_current_project?)
  end
end
