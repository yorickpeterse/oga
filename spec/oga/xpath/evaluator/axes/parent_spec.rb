require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'parent axis' do
    before do
      @document = parse('<a><b></b></a>')

      @a1 = @document.children[0]
    end

    example 'return an empty node set for non existing parents' do
      evaluate_xpath(@document, 'parent::a').should == node_set
    end

    example 'return a node set containing parents of a node' do
      evaluate_xpath(@document, 'a/b/parent::a').should == node_set(@a1)
    end

    example 'return a node set containing parents of a node using the short form' do
      evaluate_xpath(@document, 'a/b/..').should == node_set(@a1)
    end
  end
end
