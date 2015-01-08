require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'namespace axis' do
    before do
      @document = parse('<root xmlns:x="x"><foo xmlns:y="y"></foo></root>')

      @ns_x = @document.children[0].namespaces['x']
      @ns_y = @document.children[0].children[0].namespaces['y']
    end

    it 'returns an empty node set for the document' do
      evaluate_xpath(@document, 'namespace::*').should == node_set
    end

    it 'returns a node set containing the namespaces for root' do
      evaluate_xpath(@document, 'root/namespace::x').should == node_set(@ns_x)
    end

    it 'returns a node set containing the namespaces for root/foo' do
      evaluate_xpath(@document, 'root/foo/namespace::*')
        .should == node_set(@ns_y, @ns_x)
    end

    it 'returns a node set containing the namespaces for root using a wildcard' do
      evaluate_xpath(@document, 'root/namespace::*').should == node_set(@ns_x)
    end
  end
end
