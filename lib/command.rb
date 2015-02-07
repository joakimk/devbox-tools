class Command
  def list
    {}
  end

  def run(name)
    raise "Unimplemented run for #{name}"
  end

  def match?(name)
    list[name]
  end
end
