require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document = parse('<a xmlns:ns1="x">Foo<b></b><b></b><ns1:c></ns1:c></a>')
  end

  context 'absolute paths' do
    before do
      @set = described_class.new(@document).evaluate('/a')
    end

    it_behaves_like :node_set, :length => 1

    example 'return the correct nodes' do
      @set[0].should == @document.children[0]
    end
  end

  context 'absolute paths from an element' do
    before do
      b_node = @document.children[0].children[0]
      @set   = described_class.new(b_node).evaluate('/a')
    end

    it_behaves_like :node_set, :length => 1

    example 'return the correct nodes' do
      @set[0].should == @document.children[0]
    end
  end

  context 'invalid absolute paths' do
    before do
      @set = described_class.new(@document).evaluate('/x/a')
    end

    it_behaves_like :node_set, :length => 0
  end

  context 'relative paths' do
    before do
      @set = described_class.new(@document).evaluate('a')
    end

    it_behaves_like :node_set, :length => 1

    example 'return the correct nodes' do
      @set[0].should == @document.children[0]
    end
  end

  context 'invalid relative paths' do
    before do
      @set = described_class.new(@document).evaluate('x/a')
    end

    it_behaves_like :node_set, :length => 0
  end

  context 'nested paths' do
    before do
      @set = described_class.new(@document).evaluate('/a/b')
    end

    it_behaves_like :node_set, :length => 2

    example 'return the correct nodes' do
      a = @document.children[0]

      @set[0].should == a.children[1]
      @set[1].should == a.children[2]
    end
  end

  context 'namespaced paths' do
    before do
      @set = described_class.new(@document).evaluate('a/ns1:c')
    end

    it_behaves_like :node_set, :length => 1

    example 'return the correct row' do
      a = @document.children[0]

      @set[0].should == a.children[-1]
    end
  end
end
