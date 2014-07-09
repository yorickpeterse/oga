require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document  = parse('<a><b></b><b></b><ns1:c></ns1:c></a>')
    @evaluator = described_class.new(@document)
  end

  context 'full wildcards' do
    before do
      @set = @evaluator.evaluate('a/*')
    end

    example 'retunr the right amount of rows' do
      @set.length.should == 3
    end

    example 'include the first <b> node' do
      @set[0].name.should == 'b'
    end

    example 'include the second <b> node' do
      @set[1].name.should == 'b'
    end

    example 'include the <ns1:c> node' do
      @set[2].name.should      == 'c'
      @set[2].namespace.should == 'ns1'
    end
  end

  context 'namespace wildcards' do
    before do
      @set = @evaluator.evaluate('a/*:b')
    end

    example 'return the right amount of rows' do
      @set.length.should == 2
    end

    example 'include the first <b> node' do
      @set[0].name.should == 'b'
    end

    example 'include the second <b> node' do
      @set[1].name.should == 'b'
    end

    example 'ensure the nodes are the individual <b> nodes' do
      @set[0].should_not == @set[1]
    end
  end

  context 'name wildcards' do
    before do
      @set = @evaluator.evaluate('a/ns1:*')
    end

    example 'return the right amount of rows' do
      @set.length.should == 1
    end

    example 'include the correct <c> node' do
      @set[0].name.should      == 'c'
      @set[0].namespace.should == 'ns1'
    end
  end
end
