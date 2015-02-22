class HerokuDependency < SystemSoftwareDependency
  def name
    "heroku"
  end

  # Don't cache
  def cache_key
    nil
  end

  def remove
    Shell.run("sudo apt-get remove heroku-toolbelt -y")
  end

  private

  def installed?
    File.exists?(version_metadata_path)
  end

  def build_and_install_command
    %{
      wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
      mkdir -p #{metadata_path}

      # caching heroku version as metadata since quering for every time takes too long
      heroku --version 2> /dev/null|grep heroku-toolbelt > #{version_metadata_path}
    }
  end

  def version
    if File.exists?(version_metadata_path)
      # Extract "3.26.0" from "heroku-toolbelt/3.26.0 (x86_64-linux) ruby/1.8.7\n"
      File.read(version_metadata_path).match(/.+?\/(.+?) /)[1]
    else
      "latest"
    end
  end

  def version_source
    "latest at #{install_time}"
  end

  def install_time
    timestamp = exec_command("stat -c \"%Y\" $f #{version_metadata_path}").to_i
    format_time Time.at(timestamp)
  end

  # no strftime in mruby
  def format_time(time)
    year, month, day = time.year, time.month, time.day
    month = "0" + month.to_s if month < 10
    day = "0" + day.to_s if day < 10
    "#{year}-#{month}-#{day}"
  end

  def version_metadata_path
    File.join(metadata_path, "heroku_version")
  end

  def metadata_path
    Devbox.metadata_path
  end
end
