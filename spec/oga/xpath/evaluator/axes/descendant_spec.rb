require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'descendant axis' do
    before do
      @document = parse('<a><b><c></c></b><a></a></a>')

      @a1 = @document.children[0]
      @a2 = @a1.children[-1]
      @c1 = @a1.children[0].children[0]
    end

    example 'return a node set containing a direct descendant' do
      evaluate_xpath(@document, 'descendant::a').should == node_set(@a1, @a2)
    end

    example 'return a node set containing a nested descendant' do
      evaluate_xpath(@document, 'descendant::c').should == node_set(@c1)
    end

    example 'return a node set containing a descendant relative to a node' do
      evaluate_xpath(@document, 'a/descendant::a').should == node_set(@a2)
    end

    example 'return an empty node set for non existing descendants' do
      evaluate_xpath(@document, 'a/b/c/descendant::c').should == node_set
    end
  end
end
