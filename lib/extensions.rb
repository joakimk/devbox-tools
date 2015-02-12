class File
  def self.readlines(path)
    read(path).split("\n")
  end
end
