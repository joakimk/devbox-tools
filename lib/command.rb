class Command
  def options
    {}
  end

  def run(name)
    raise "Unimplemented run for #{name}"
  end

  def match?(name)
    options[name]
  end

  def log(message, &block)
    logger.log(message, &block)
  end

  def logger
    Logger.new
  end
end
