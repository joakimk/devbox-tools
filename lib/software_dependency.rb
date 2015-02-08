class SoftwareDependency < Dependency
  def install
    raise "not implemented"
  end

  def start
    # no-op
  end

  def environment_variables(envs)
    envs["PATH"] = "#{install_prefix}/bin:#{envs["PATH"]}"
    envs
  end

  private

  def install_prefix
    "#{Devbox.code_root}/dependencies/#{name}"
  end

  def project_root
    Devbox.project_root
  end
end
