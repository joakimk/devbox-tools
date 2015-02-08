class Build
  def initialize(dependency_name)
    @dependency_name = dependency_name
  end

  def in_temporary_path
    command = yield

    build_command = %{
      set -e
      mkdir -p #{build_path}
      cd #{build_path}
      #{command}
    }

    Shell.run(build_command)
  ensure
    system("rm -rf #{build_path}")
  end

  private

  def build_path
    "/tmp/build/#{dependency_name}"
  end

  attr_reader :dependency_name
end
