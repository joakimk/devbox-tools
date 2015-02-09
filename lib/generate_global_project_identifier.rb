# When caching code and data for a project that others can reuse you want
# to be able to uniquely identify a project (name is not enough,
# there can be duplicates, local paths can differ, ...).
#
# One simple way to generate such an identifier is to base it on the project's
# git origin url. Support for other forms of identification can be added if needed.

class GenerateGlobalProjectIdentifier
  def self.call(git_origin_url)
    return nil unless git_origin_url
    _, host, path = git_origin_url.match(/(?:git@|https:\/\/)(.+?)[:\/](.+)/).to_a
    Digest::MD5.hexdigest(host + path)
  end
end
