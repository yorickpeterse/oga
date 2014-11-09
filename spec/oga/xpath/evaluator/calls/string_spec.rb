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
    end

    example 'convert the <root> node to a string' do
      evaluate_xpath(@document, 'string(root)')
        .should == "\n  a1\n  b1\n  \n  foobar\n"
    end

    example 'convert the <a> node to a string' do
      evaluate_xpath(@document, 'string(root/a)').should == 'a1'
    end

    example 'convert the <b> node to a string' do
      evaluate_xpath(@document, 'string(root/b)').should == 'b1'
    end

    example 'convert the "num" attribute to a string' do
      evaluate_xpath(@document, 'string(root/b/@num)').should == '10'
    end

    example 'convert the first node in a set to a string' do
      evaluate_xpath(@document, 'string(root/*)').should == 'a1'
    end

    example 'convert an integer to a string' do
      evaluate_xpath(@document, 'string(10)').should == '10'
    end

    example 'convert a float to a string' do
      evaluate_xpath(@document, 'string(10.5)').should == '10.5'
    end

    example 'convert a string to a string' do
      evaluate_xpath(@document, 'string("foo")').should == 'foo'
    end

    example 'convert a comment to a string' do
      evaluate_xpath(@document, 'string(root/c/comment())').should == 'foo'
    end

    example 'convert a CDATA to a string' do
      evaluate_xpath(@document, 'string(root/d/node())').should == 'foobar'
    end

    example 'return an empty string by default' do
      evaluate_xpath(@document, 'string(foobar)').should == ''
    end

    example 'return a node set containing nodes with certain text' do
      b = @document.children[0].children[1].next_element

      evaluate_xpath(@document, 'root/b[string() = "b1"]')
        .should == node_set(b)
    end
  end
end
