require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'last() function' do
    before do
      @document = parse('<root><a>foo</a><a>bar</a></root>')
      @second_a = @document.children[0].children[1]
      @set      = described_class.new(@document).evaluate('root/a[last()]')
    end

    it_behaves_like :node_set, :length => 1

    example 'return the second <a> node' do
      @set[0].should == @second_a
    end
  end
end
