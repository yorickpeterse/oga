namespace :build do
  desc 'Builds a new Gem'
  task :gem => [:clean, :build] do
    Rake::Task['checksum'].invoke
  end

  desc 'Builds a new Java Gem'
  task :java do
    sh 'chruby-exec jruby -- rake build:gem'
  end

  desc 'Builds all Gems'
  task :all => [:gem, :java]
end

task :build => [:generate]
