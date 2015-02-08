class Logger
  module Loggable
    def log(message, &block)
      Logger.new.log(message, &block)
    end
  end

  def log(message, &block)
    if block
      event "#{message}..."
      finish_message = block.call || "done"
      detail finish_message
    else
      event "#{message}."
    end
  end

  def event(message)
    puts "#{start_tags} #{message}"
  end

  def detail(text)
    puts "   " + text
  end

  private

  def start_tags
    start_tags = "\e[1;34;30m>>\e[0m"
  end
end
