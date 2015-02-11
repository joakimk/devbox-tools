class Shell
  def self.run(command)
    command_file_path = "/tmp/command-#{Digest::MD5.hexdigest(command)}.sh"

    # get around escaping issues
    File.open(command_file_path, "w") { |f|
      f.puts(command + " 2>&1")
    }

    if ENV["DEBUG"]
      puts
      puts "Running command:"
      puts command
      puts
    end

    command = ENV["DEBUG"] ?
      "sh #{command_file_path}" :
      "sh #{command_file_path} 2>&1 > /dev/null"

    system(command) || raise("Failed to command: #{command}")
    system("rm #{command_file_path}") || exit(1)
  end
end
