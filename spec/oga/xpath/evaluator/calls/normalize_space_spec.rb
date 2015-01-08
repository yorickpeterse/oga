require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'normalize-space() function' do
    before do
      @document = parse('<root><a> fo   o </a></root>')
    end

    it 'normalizes a literal string' do
      evaluate_xpath(@document, 'normalize-space(" fo  o ")').should == 'fo o'
    end

    it 'normalizes a string in a node set' do
      evaluate_xpath(@document, 'normalize-space(root/a)').should == 'fo o'
    end

    it 'normalizes an integer' do
      evaluate_xpath(@document, 'normalize-space(10)').should == '10'
    end

    it 'normalizes a float' do
      evaluate_xpath(@document, 'normalize-space(10.5)').should == '10.5'
    end

    it 'returns a node set containing nodes with normalized spaces' do
      evaluate_xpath(@document, 'root/a[normalize-space()]')
        .should == node_set(@document.children[0].children[0])
    end
  end
end
