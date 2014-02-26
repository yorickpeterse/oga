desc 'Creates a SHA512 checksum of the current version'
task :checksum do
  checksums = File.expand_path('../../checksum', __FILE__)
  name      = "#{GEMSPEC.name}-#{GEMSPEC.version}.gem"
  path      = File.join(File.expand_path('../../pkg', __FILE__), name)

  checksum_name = File.basename(path) + '.sha512'
  checksum      = Digest::SHA512.new.hexdigest(File.read(path))

  File.open(File.join(checksums, checksum_name), 'w') do |handle|
    handle.write(checksum)
  end
end
