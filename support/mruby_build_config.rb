MRuby::Build.new do |conf|
  toolchain :gcc

  # Versions only locked down for reliability, could probably be upgraded

  # Add "File", etc.
  conf.gem :github => "iij/mruby-io", :checksum_hash => "3a97a453c486cd1ce9456970b686ab24f8126980"

  # Test framework
  conf.gem :github => "iij/mruby-mtest", :checksum_hash => "dab50c72018fb4ae9ecd5855ac5fe3001a3246fa"

  # Add "require" and it's deps
  conf.gem :github => "iij/mruby-require", :checksum_hash => "6ced4881e88854fd3e749aa30e042440a6c4de6a"
  conf.gem :github => "iij/mruby-dir", :checksum_hash => "6cc24d07935a265df6edad4352ece1b1c3aca8dc"
  conf.gem :github => "iij/mruby-tempfile", :checksum_hash => "48f92e93bc212ab8ea2f4c68e3564573e64877d8"
  conf.gem "mrbgems/mruby-eval"

  # Add "system"
  conf.gem :github => "hiroeorz/mruby-syscommand", :checksum_hash => "9ea1f4fbe77d472254da7fe2a4487212a06e4fb0"

  # Add "exit"
  conf.gem "mrbgems/mruby-exit"

  # Add ENV
  conf.gem :github => "iij/mruby-env", :checksum_hash => "0b9af96e7286eb4ad2300ceace9c11ac39c8d684"

  # Add Regexp
  conf.gem :github => "iij/mruby-regexp-pcre", :checksum_hash => "79ade385e92332a67eff8600f04f800d7cf5ebae"

  # Add hexdigest
  conf.gem :github => "iij/mruby-digest", :checksum_hash => "89dd8f7c69ea6783481560a223aed1c75eb07316"

  # Add YAML
  conf.gem :github => "AndrewBelt/mruby-yaml", :checksum_hash => "33887291adb31977ced2be7f56bf15f74816df7a"

  # Add JSON
  conf.gem :github => "iij/mruby-iijson", :checksum_hash => "e5c0c4594d2d289f74cfd6038b54f701f8e38bba"

  # Adds default gems, seems like a good idea.
  conf.gembox 'default'
end
