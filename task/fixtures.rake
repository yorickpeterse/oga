desc 'Generates large XML fixtures'
task :fixtures do
  dest = File.expand_path('../../benchmark/fixtures/big.xml.gz', __FILE__)

  unless File.file?(dest)
    sh "wget http://downloads.yorickpeterse.com/files/big_xml_file.xml.gz -O #{dest}"
    sh "gunzip #{dest}"
  end
end
