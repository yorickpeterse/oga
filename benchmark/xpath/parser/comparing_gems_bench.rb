require_relative '../../benchmark_helper'

require 'nokogiri'
require 'ox'
require 'rexml/document'

xml = '<root><number>10</number></root>'

ox_doc   = Ox.parse(xml)
noko_doc = Nokogiri::XML(xml)
oga_doc  = Oga::XML::Parser.new(xml).parse
rex_doc  = REXML::Document.new(xml)

ox_exp    = 'number/^Text'
xpath_exp = 'root/number/text()'

Benchmark.ips do |bench|
  # Technically not XPath but it's the closest thing Ox provides.
  bench.report 'Ox' do
    ox_doc.locate(ox_exp)
  end

  bench.report 'Nokogiri' do
    noko_doc.xpath(xpath_exp)
  end

  bench.report 'Oga' do
    oga_doc.xpath(xpath_exp)
  end

  bench.report 'REXML' do
    REXML::XPath.match(rex_doc, xpath_exp)
  end

  bench.compare!
end
