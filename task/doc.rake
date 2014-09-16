namespace :doc do
  desc 'Generates YARD documentation'
  task :build => :generate do
    sh 'yard'
  end

  desc 'Generates and uploads the documentation'
  task :upload => :build do
    root_dir    = "/srv/http/code.yorickpeterse.com/public/oga"
    version_dir = File.join(root_dir, Oga::VERSION)

    sh "scp -r yardoc europa:#{version_dir}"

    sh "ssh europa 'rm -f #{root_dir}/latest " \
      "&& ln -s #{version_dir} #{root_dir}/latest'"
  end
end
