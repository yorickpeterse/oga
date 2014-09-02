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

oga_ast   = Oga::XPath::Parser.new(xpath_exp).parse
evaluator = Oga::XPath::Evaluator.new(oga_doc)

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

  # This is measured to see what the performance of the evaluator is _without_
  # the overhead of the lexer/parser.
  bench.report 'Oga cached' do
    evaluator.evaluate_ast(oga_ast)
  end

  bench.report 'REXML' do
    REXML::XPath.match(rex_doc, xpath_exp)
  end

  bench.compare!
end
