require_relative '../../benchmark_helper'

require 'nokogiri'
require 'ox'
require 'rexml/document'

xml = read_big_xml

Benchmark.ips do |bench|
  bench.report 'Ox' do
    Ox.parse(xml)
  end

  bench.report 'Nokogiri' do
    Nokogiri::XML(xml)
  end

  bench.report 'Oga' do
    Oga::XML::Parser.new(xml).parse
  end

  bench.report 'REXML' do
    REXML::Document.new(xml)
  end

  bench.compare!
end
