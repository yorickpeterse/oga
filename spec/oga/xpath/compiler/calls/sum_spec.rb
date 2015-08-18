require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'sum() spec' do
    before do
      @document = parse('<root><a>1</a><b>2</b></root>')

      @a1 = @document.children[0].children[0]
    end

    describe 'at the top-level' do
      it 'returns the sum of the <root> node' do
        # The test of <root> is "12", which is then converted to a number.
        evaluate_xpath(@document, 'sum(root)').should == 12.0
      end

      it 'returns the sum of the child nodes of the <root> node' do
        evaluate_xpath(@document, 'sum(root/*)').should == 3.0
      end

      it 'returns zero by default' do
        evaluate_xpath(@document, 'sum(foo)').should be_zero
      end

      it 'raises a TypeError for non node set arguments' do
        block = -> { evaluate_xpath(@document, 'sum("foo")') }

        block.should raise_error(TypeError)
      end
    end

    describe 'in a predicate' do
      it 'returns a NodeSet containing all matching nodes' do
        evaluate_xpath(@document, 'root/a[sum(/root/*)]')
          .should == node_set(@a1)
      end
    end
  end
end
