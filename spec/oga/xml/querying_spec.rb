require 'spec_helper'

describe Oga::XML::Querying do
  before do
    @document = parse('<a>foo</a>')
  end

  context '#xpath' do
    example 'query a document' do
      @document.xpath('a')[0].name.should == 'a'
    end

    example 'query an element' do
      @document.children[0].xpath('text()')[0].text.should == 'foo'
    end

    example 'evaluate an expression using a variable' do
      @document.xpath('$number', 'number' => 10).should == 10
    end
  end

  context '#at_xpath' do
    example 'query a document' do
      @document.at_xpath('a').name.should == 'a'
    end

    example 'query an element' do
      @document.children[0].at_xpath('text()').text.should == 'foo'
    end

    example 'evaluate an expression using a variable' do
      @document.at_xpath('$number', 'number' => 10).should == 10
    end
  end

  context '#css' do
    example 'query a document' do
      @document.css('a').should == @document.children
    end
  end

  context '#at_css' do
    example 'query a document' do
      @document.at_css('a').should == @document.children[0]
    end
  end
end
