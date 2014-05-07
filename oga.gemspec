require File.expand_path('../lib/oga/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'oga'
  s.version     = Oga::VERSION
  s.authors     = ['Yorick Peterse']
  s.email       = 'yorickpeterse@gmail.com'
  s.summary     = 'A pure Ruby HTML/XML parser.'
  s.homepage    = 'https://github.com/yorickpeterse/oga/'
  s.description = s.summary
  s.license     = 'MIT'

  s.files = Dir.glob([
    'checkum/**/*.*',
    'doc/**/*.*',
    'lib/**/*.rb',
    'ext/**/*.*',
    'README.md',
    'LICENSE',
    'MANIFEST',
    'oga.gemspec',
    '.yardopts'
  ])

  if RUBY_PLATFORM == 'java'
    s.files << 'lib/liboga.jar'

    s.platform = 'java'
  else
    s.extensions = ['ext/c/extconf.rb']
  end

  s.has_rdoc              = 'yard'
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'racc'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'kramdown'
  s.add_development_dependency 'benchmark-ips'
  s.add_development_dependency 'rake-compiler'
end
