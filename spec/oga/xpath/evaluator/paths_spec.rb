require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'paths' do
    before do
      @document = parse('<a xmlns:ns1="x">Foo<b></b><b></b><ns1:c></ns1:c></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[1]
      @b2 = @a1.children[2]
    end

    example 'evaluate an absolute path' do
      evaluate_xpath(@document, '/a').should == node_set(@a1)
    end

    example 'evaluate an absolute path relative to a sub node' do
      b_node = @document.children[0].children[0]

      evaluate_xpath(b_node, '/a').should == node_set(@a1)
    end

    example 'evaluate the root selector' do
      evaluate_xpath(@document, '/').should == node_set(@document)
    end

    example 'evaluate a relative path' do
      evaluate_xpath(@document, 'a').should == node_set(@a1)
    end

    example 'evaluate a relative path that returns an empty node set' do
      evaluate_xpath(@document, 'x/a').should == node_set
    end

    example 'evaluate a nested absolute path' do
      evaluate_xpath(@document, '/a/b').should == node_set(@b1, @b2)
    end

    example 'evaluate an absolute path that returns an empty node set' do
      evaluate_xpath(@document, '/x/a').should == node_set
    end

    example 'evaluate a namespaced path' do
      evaluate_xpath(@document, 'a/ns1:c').should == node_set(@a1.children[-1])
    end
  end
end
