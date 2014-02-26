desc 'Builds a new Gem and its checksum'
task :signed_build => [:build] do
  Rake::Task['checksum'].invoke
end
