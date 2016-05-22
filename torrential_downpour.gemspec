version = File.read("VERSION").strip

Gem::Specification.new do |s|
  s.name	= 'torrential_downpour'
  s.version	= version
  s.platform    = Gem::Platform::RUBY
  s.summary	= "Automate the searching, tracking, and alerting of new available torrents"
  s.author	= "Jason Hines"
  s.email	= "jason@devtwo.com"
  s.homepage	= "https://github.com/openface/torrential_downpour"

  s.files	=  Dir['README.md', 'VERSION', 'Gemfile', '{bin,lib}/*', '*.sample.yml']
  s.executables   = %w[torrential_downpour]
  s.require_paths = %w[lib]
  
  s.add_dependency 'transmission_api'
  s.add_dependency 'pirata'
  s.add_dependency 'foreverb'
end
