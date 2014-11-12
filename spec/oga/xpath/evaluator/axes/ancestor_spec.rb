require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'ancestor axis' do
    before do
      @document = parse('<a><b><c></c></b></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[0]
      @c1 = @b1.children[0]
    end

    example 'return a node set containing a direct ancestor' do
      evaluate_xpath(@c1, 'ancestor::b').should == node_set(@b1)
    end

    example 'return a node set containing a higher ancestor' do
      evaluate_xpath(@c1, 'ancestor::a').should == node_set(@a1)
    end

    example 'return a node set containing the first ancestor' do
      evaluate_xpath(@c1, 'ancestor::*[1]').should == node_set(@b1)
    end

    example 'return an empty node set for non existing ancestors' do
      evaluate_xpath(@c1, 'ancestor::c').should == node_set
    end
  end
end
