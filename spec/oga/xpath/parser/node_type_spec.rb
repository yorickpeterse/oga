require 'spec_helper'

describe Oga::XPath::Parser do
  context 'node types' do
    example 'parse the "node" type' do
      parse_xpath('node()').should == s(:axis, 'child', s(:type_test, 'node'))
    end

    example 'parse the "comment" type' do
      parse_xpath('comment()')
        .should == s(:axis, 'child', s(:type_test, 'comment'))
    end

    example 'parse the "text" type' do
      parse_xpath('text()').should == s(:axis, 'child', s(:type_test, 'text'))
    end

    example 'parse the "processing-instruction" type' do
      parse_xpath('processing-instruction()')
        .should == s(:axis, 'child', s(:type_test, 'processing-instruction'))
    end
  end
end
