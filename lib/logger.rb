class Logger
  def log(message, &block)
    start_tags = "\e[1;34;30m>>\e[0m"

    if block
      inline "#{start_tags} #{message}..."
      finish_message = block.call || "done"
      line finish_message + "."
    else
      line "#{start_tags} #{message}."
    end
  end

  def inline(text)
    print text + " "; STDOUT.flush
  end

  def line(text)
    puts text
  end
end
