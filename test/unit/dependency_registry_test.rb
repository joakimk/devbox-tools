class DependencyRegistryTest < TestCase
  test "returns dependencies sorted by dependencies" do
    DependencyRegistry.list.clear
    DependencyRegistry.register(FooDependency.new)
    DependencyRegistry.register(BarDependency.new)
    assert_equal [ "bar", "foo" ], DependencyRegistry.dependencies_used_by_the_current_project.map(&:name)
  end

  test "raises if a dependency of a dependency does not exist" do
    DependencyRegistry.list.clear
    DependencyRegistry.register(BazDependency.new)
    DependencyRegistry.register(BarDependency.new)

    begin
      DependencyRegistry.dependencies_used_by_the_current_project
    rescue => ex
      assert_include ex.message, 'depend on "unknown"'
    else
      raise "Expected exception"
    end
  end

  class FooDependency
    def name
      "foo"
    end

    def dependencies
      [ "bar" ]
    end

    def used_by_current_project?
      true
    end
  end

  class BarDependency
    def name
      "bar"
    end

    def dependencies
      []
    end

    def used_by_current_project?
      true
    end
  end

  class BazDependency
    def name
      "baz"
    end

    def dependencies
      [ "unknown" ]
    end

    def used_by_current_project?
      true
    end
  end
end
