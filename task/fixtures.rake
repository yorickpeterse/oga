rule '.xml' => '.xml.gz' do |task|
  sh "gunzip #{task.source} --keep"
end

desc 'Generates large XML fixtures'
task :fixtures => ['benchmark/fixtures/big.xml', 'benchmark/fixtures/kaf.xml']
