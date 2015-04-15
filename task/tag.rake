desc 'Creates a Git tag for the current version'
task :tag do
  version = Oga::VERSION

  sh %Q{git tag -a -m "Release #{version}" v#{version}}
end
