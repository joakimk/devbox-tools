class Build
  def initialize(dependency_name)
    @dependency_name = dependency_name
  end

  def in_temporary_path
    command = yield

    build_command = %{
      set -e
      mkdir -p #{path}
      cd #{path}
      (#{command}) 2>&1
    }

    ShellRunner.run(build_command)
  ensure
    system("rm -rf #{path}")
  end

  def path
    "/tmp/build/#{dependency_name}"
  end

  private

  attr_reader :dependency_name
end
