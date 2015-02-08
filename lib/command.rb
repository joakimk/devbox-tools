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

  def log(message, &block)
    logger.log(message, &block)
  end

  def logger
    Logger.new
  end
end
