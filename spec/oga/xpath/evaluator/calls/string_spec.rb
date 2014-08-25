require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'string() function' do
    before do
      @document = parse(<<-EOF)
<root>
  <a>a1</a>
  <b num="10">b1</b>
  <c><!--foo--></c>
  <d><![CDATA[foobar]]></d>
</root>
      EOF
      @evaluator = described_class.new(@document)
    end

    context 'outside predicates' do
      example 'convert the <root> node to a string' do
        @evaluator.evaluate('string(root)')
          .should == "\n  a1\n  b1\n  \n  foobar\n"
      end

      example 'convert the <a> node to a string' do
        @evaluator.evaluate('string(root/a)').should == 'a1'
      end

      example 'convert the <b> node to a string' do
        @evaluator.evaluate('string(root/b)').should == 'b1'
      end

      example 'convert the "num" attribute to a string' do
        @evaluator.evaluate('string(root/b/@num)').should == '10'
      end

      example 'convert the first node in a set to a string' do
        @evaluator.evaluate('string(root/*)').should == 'a1'
      end

      example 'convert an integer to a string' do
        @evaluator.evaluate('string(10)').should == '10'
      end

      example 'convert a float to a string' do
        @evaluator.evaluate('string(10.5)').should == '10.5'
      end

      example 'convert a string to a string' do
        @evaluator.evaluate('string("foo")').should == 'foo'
      end

      example 'convert a comment to a string' do
        @evaluator.evaluate('string(root/c/comment())').should == 'foo'
      end

      example 'convert a CDATA to a string' do
        @evaluator.evaluate('string(root/d/node())').should == 'foobar'
      end

      example 'return an empty string by default' do
        @evaluator.evaluate('string(foobar)').should == ''
      end
    end

    context 'inside predicates' do
      before do
        @set = @evaluator.evaluate('root/b[string()]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <b> node' do
        @set[0].name.should == 'b'
      end
    end
  end
end
