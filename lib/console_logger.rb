class ConsoleLogger
  module Loggable
    def log(message, &block)
      ConsoleLogger.new.log(message, &block)
    end
  end

  def log(message, &block)
    if block
      event "#{message}..."
      finish_message = block.call
      finish_message = "done" unless finish_message.is_a?(String)
      detail finish_message
    else
      event message.end_with?(".") ? message : "#{message}."
    end
  end

  def event(message)
    puts "#{start_tags} #{message}"
  end

  def detail(text)
    puts "   " + text
  end

  def debug(file, message)
    return unless Devbox.debug?
    local_path = file.gsub(Devbox.tools_root + "/", "")
    puts "DEBUG: [#{local_path}] #{message}"
  end

  private

  def start_tags
    start_tags = "\e[1;34;30m>>\e[0m"
  end
end
