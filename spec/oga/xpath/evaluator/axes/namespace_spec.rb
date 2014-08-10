require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'namespace axis' do
    before do
      @document = parse(<<-EOF.strip)
<root xmlns:x="x">
  <foo xmlns:y="y"></foo>
</root>
      EOF

      @evaluator = described_class.new(@document)
    end

    context 'matching namespaces in the entire document' do
      before do
        @set = @evaluator.evaluate('namespace::*')
      end

      it_behaves_like :empty_node_set
    end

    context 'matching namespaces in the root element' do
      before do
        @set = @evaluator.evaluate('root/namespace::x')
      end

      it_behaves_like :node_set, :length => 1

      example 'return a Namespace instance' do
        @set[0].is_a?(Oga::XML::Namespace).should == true
      end

      example 'return the "x" namespace' do
        @set[0].name.should == 'x'
      end
    end

    context 'matching namespaces in a nested element' do
      before do
        @set = @evaluator.evaluate('root/foo/namespace::*')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the "y" namespace' do
        @set[0].name.should == 'y'
      end

      example 'return the "x" namespace' do
        @set[1].name.should == 'x'
      end
    end

    context 'matching namespace nodes using a wildcard' do
      before do
        @set = @evaluator.evaluate('root/namespace::*')
      end

      it_behaves_like :node_set, :length => 1
    end
  end
end
