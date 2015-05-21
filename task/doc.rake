namespace :doc do
  desc 'Generates YARD documentation'
  task :build => :generate do
    sh 'yard'
  end

  desc 'Generates and uploads the documentation'
  task :upload => :build do
    version     = GEMSPEC.version.to_s
    bucket      = 's3://code.yorickpeterse.com'
    directory   = GEMSPEC.name

    sh "aws s3 rm --recursive #{bucket}/#{directory}/latest"
    sh "aws s3 sync yardoc #{bucket}/#{directory}/#{version} --acl public-read"
    sh "aws s3 sync yardoc #{bucket}/#{directory}/latest --acl public-read"
  end
end
