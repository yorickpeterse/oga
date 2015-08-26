require 'spec_helper'

describe Oga::XPath::Parser do
  describe 'node() type test' do
    it 'parses the standalone type test' do
      parse_xpath('node()').should == s(:axis, 'child', s(:type_test, 'node'))
    end

    it 'parses the type test in a predicate' do
      parse_xpath('node()[1]').should == s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'node')),
        s(:int, 1)
      )
    end
  end

  describe 'comment() type test' do
    it 'parses the standalone type test' do
      parse_xpath('comment()').should == s(:axis, 'child', s(:type_test, 'comment'))
    end

    it 'parses the type test in a predicate' do
      parse_xpath('comment()[1]').should == s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'comment')),
        s(:int, 1)
      )
    end
  end

  describe 'text() type test' do
    it 'parses the standalone type test' do
      parse_xpath('text()').should == s(:axis, 'child', s(:type_test, 'text'))
    end

    it 'parses the type test in a predicate' do
      parse_xpath('text()[1]').should == s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'text')),
        s(:int, 1)
      )
    end
  end

  describe 'processing-instruction() type test' do
    it 'parses the standalone type test' do
      parse_xpath('processing-instruction()').should ==
        s(:axis, 'child', s(:type_test, 'processing-instruction'))
    end

    it 'parses the type test in a predicate' do
      parse_xpath('processing-instruction()[1]').should == s(
        :predicate,
        s(:axis, 'child', s(:type_test, 'processing-instruction')),
        s(:int, 1)
      )
    end
  end
end
