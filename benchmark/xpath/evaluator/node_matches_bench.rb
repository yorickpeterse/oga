require_relative '../../benchmark_helper'

xml_node = Oga::XML::Element.new(:name => 'foo')

name_only    = AST::Node.new(:test, [nil, 'foo'])
name_star    = AST::Node.new(:test, [nil, '*'])
name_ns_star = AST::Node.new(:test, ['*', 'foo'])
name_ns      = AST::Node.new(:test, ['bar', 'foo'])

evaluator = Oga::XPath::Evaluator.new(xml_node)

Benchmark.ips do |bench|
  bench.report 'name only' do
    evaluator.node_matches?(xml_node, name_only)
  end

  bench.report 'name wildcard' do
    evaluator.node_matches?(xml_node, name_star)
  end

  bench.report 'name + namespace' do
    evaluator.node_matches?(xml_node, name_ns)
  end

  bench.report 'namespace wildcard' do
    evaluator.node_matches?(xml_node, name_ns_star)
  end

  bench.compare!
end
