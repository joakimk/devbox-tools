require "devbox"

class Finder
  def self.ruby_files(relative_path, root = Devbox.tools_root)
    files(relative_path, root).select { |path| path.include?(".rb") }
  end

  def self.files(relative_path, root = "/")
    directory = File.join(root, relative_path)
    return [] unless File.directory?(directory)

    Dir.entries(directory).
      reject { |name| name == "." || name == ".." }.
      map { |name| "#{directory}/#{name}" }
  end
end
