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
end
