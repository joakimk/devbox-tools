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
    start_tags = "\e[1;34;30m>>\e[0m"

    if block
      print "#{start_tags} #{message}... "; STDOUT.flush
      finish_message = block.call || "done"
      puts finish_message + "."
    else
      puts "#{start_tags} #{message}."
    end
  end
end
