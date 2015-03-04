require "digest"

class ShellRunner
  def self.run(command, options = {})
    may_fail = options.fetch(:may_fail, false)

    command_file_path = "/tmp/command-#{Digest::MD5.hexdigest(command)}.sh"

    # get around escaping issues
    File.open(command_file_path, "w") { |f|
      f.puts(command + " 2>&1")
    }

    if Devbox.debug?
      puts
      puts "Running command:"
      puts command
      puts
    end

    command = Devbox.debug? ?
      "sh #{command_file_path}" :
      "sh #{command_file_path} 2>&1 > /dev/null"

    success = system(command)

    if !success && !may_fail
      raise("Failed to command: #{command}")
    end

    system("rm #{command_file_path}") || exit(1)
    success
  end
end
