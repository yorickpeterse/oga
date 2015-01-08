require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'string() function' do
    before do
      @document = parse(<<-EOF)
<root>
  <a>a1</a>
  <b num="10">b1</b>
  <c><!--foo--></c>
  <d><![CDATA[foobar]]></d>
</root>
      EOF
    end

    it 'converts the <root> node to a string' do
      evaluate_xpath(@document, 'string(root)')
        .should == "\n  a1\n  b1\n  \n  foobar\n"
    end

    it 'converts the <a> node to a string' do
      evaluate_xpath(@document, 'string(root/a)').should == 'a1'
    end

    it 'converts the <b> node to a string' do
      evaluate_xpath(@document, 'string(root/b)').should == 'b1'
    end

    it 'converts the "num" attribute to a string' do
      evaluate_xpath(@document, 'string(root/b/@num)').should == '10'
    end

    it 'converts the first node in a set to a string' do
      evaluate_xpath(@document, 'string(root/*)').should == 'a1'
    end

    it 'converts an integer to a string' do
      evaluate_xpath(@document, 'string(10)').should == '10'
    end

    it 'converts a float to a string' do
      evaluate_xpath(@document, 'string(10.5)').should == '10.5'
    end

    it 'converts a string to a string' do
      evaluate_xpath(@document, 'string("foo")').should == 'foo'
    end

    it 'converts a comment to a string' do
      evaluate_xpath(@document, 'string(root/c/comment())').should == 'foo'
    end

    it 'converts a CDATA to a string' do
      evaluate_xpath(@document, 'string(root/d/node())').should == 'foobar'
    end

    it 'returns an empty string by default' do
      evaluate_xpath(@document, 'string(foobar)').should == ''
    end

    it 'returns a node set containing nodes with certain text' do
      b = @document.children[0].children[1].next_element

      evaluate_xpath(@document, 'root/b[string() = "b1"]')
        .should == node_set(b)
    end
  end
end
