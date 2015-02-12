class EnvsAtLogin
  def self.call
    new.call
  end

  def call
    env_lines.each_with_object({}) { |line, h|
      name, value = parse_environment_variable(line)
      h[name] = value
    }
  end

  private

  def parse_environment_variable(line)
    match =  line.match(/declare -x (.+?)="(.+?)"/) || # bash: with value
      line.match(/declare -x (.+)/) || # bash: no value
      line.match(/(.+?)=(.+)/) # zsh
    [ match[1], match[2] ]
  end

  def env_lines
    File.read("/tmp/.envs_at_login").split("\n")
  end
end
