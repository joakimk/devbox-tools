class Command
  def options
    {}
  end

  def run(option, parameters)
    raise "Unimplemented run for #{option}"
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
