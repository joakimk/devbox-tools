MRuby::Build.new do |conf|
  toolchain :gcc

  # Versions only locked down for reliability, could probably be upgraded
  conf.gem :github => "iij/mruby-io", :checksum_hash => "3a97a453c486cd1ce9456970b686ab24f8126980" # Add File, etc.

  # Adds default gems, seems like a good idea.
  conf.gembox 'default'
end
