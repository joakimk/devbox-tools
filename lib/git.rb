class Git
  def self.origin_url(path)
    remote = `cd #{path} && git config --get remote.origin.url`.chomp

    if remote == ""
      nil
    else
      remote
    end
  end
end
