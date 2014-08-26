require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'translate() function' do
    before do
      @document  = parse('<root><a>bar</a><b>abc</b><c>ABC</c></root>')
      @evaluator = described_class.new(@document)
    end

    example 'translate a string using all string literals' do
      @evaluator.evaluate('translate("bar", "abc", "ABC")').should == 'BAr'
    end

    example "remove characters that don't occur in the replacement string" do
      @evaluator.evaluate('translate("-aaa-", "abc-", "ABC")').should == 'AAA'
    end

    example 'use the first character occurence in the search string' do
      @evaluator.evaluate('translate("ab", "aba", "123")').should == '12'
    end

    example 'ignore excess characters in the replacement string' do
      @evaluator.evaluate('translate("abc", "abc", "123456")').should == '123'
    end

    example 'translate a node set string using string literals' do
      @evaluator.evaluate('translate(root/a, "abc", "ABC")').should == 'BAr'
    end

    example 'translate a node set string using other node set strings' do
      @evaluator.evaluate('translate(root/a, root/b, root/c)').should == 'BAr'
    end
  end
end
