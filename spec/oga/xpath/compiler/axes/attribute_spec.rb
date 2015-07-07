require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'attribute axis' do
    before do
      @document = parse('<a foo="bar"></a>')

      @a1   = @document.children[0]
      @attr = @a1.attribute('foo')
    end

    it 'returns a node set containing an attribute' do
      evaluate_xpath(@a1, 'attribute::foo').should == node_set(@attr)
    end

    it 'returns a node set containing an attribute using the short form' do
      evaluate_xpath(@a1, '@foo').should == node_set(@attr)
    end

    it 'returns an empty node set for non existing attributes' do
      evaluate_xpath(@a1, 'attribute::bar').should == node_set
    end
  end
end
