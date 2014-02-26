desc 'Generates the MANIFEST file'
task :manifest do
  generated = GENERATED_FILES.map { |path| File.expand_path(path) }
  files     = (`git ls-files`.split("\n") | generated).sort
  handle    = File.open(File.expand_path('../../MANIFEST', __FILE__), 'w')

  handle.write(files.join("\n"))
  handle.close
end
