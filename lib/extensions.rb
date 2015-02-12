class File
  def self.readlines(path)
    read(path).split("\n").map { |line| "#{line}\n" }
  end

  def self.write(path, content)
    File.open(path, "wb") { |f| f.puts(content) }
  end
end
