require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'position() function' do
    before do
      @document = parse('<root><a>foo</a><a>bar</a></root>')
      @set      = described_class.new(@document).evaluate('root/a[position()]')
    end

    it_behaves_like :node_set, :length => 2

    example 'return the first <a> node' do
      @set[0].should == @document.children[0].children[0]
    end

    example 'return the second <a> node' do
      @set[1].should == @document.children[0].children[1]
    end
  end
end
