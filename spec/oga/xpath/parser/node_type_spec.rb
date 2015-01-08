require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'node types' do
    it 'parses the "node" type' do
      parse_xpath('node()').should == s(:axis, 'child', s(:type_test, 'node'))
    end

    it 'parses the "comment" type' do
      parse_xpath('comment()')
        .should == s(:axis, 'child', s(:type_test, 'comment'))
    end

    it 'parses the "text" type' do
      parse_xpath('text()').should == s(:axis, 'child', s(:type_test, 'text'))
    end

    it 'parses the "processing-instruction" type' do
      parse_xpath('processing-instruction()')
        .should == s(:axis, 'child', s(:type_test, 'processing-instruction'))
    end
  end
end
