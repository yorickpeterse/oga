require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'id() function' do
    before do
      @document = parse('<root id="r1"><a id="a1"></a><a id="a2">a1</a></root>')

      @a1 = @document.children[0].children[0]
      @a2 = @document.children[0].children[1]
    end

    describe 'at the top level' do
      describe 'using a string' do
        it 'returns a NodeSet' do
          expect(evaluate_xpath(@document, 'id("a1")')).to eq(node_set(@a1))
        end
      end

      describe 'using a space separated string' do
        it 'returns a NodeSet' do
          expect(evaluate_xpath(@document, 'id("a1 a2")')).to eq(node_set(@a1, @a2))
        end
      end

      describe 'using a path' do
        it 'returns a NodeSet' do
          expect(evaluate_xpath(@document, 'id(root/a[2])')).to eq(node_set(@a1))
        end
      end
    end

    describe 'in a predicate' do
      describe 'using a string' do
        it 'matches nodes when a non-empty NodeSet is returned' do
          expect(evaluate_xpath(@document, 'root/a[id("a1")]'))
            .to eq(node_set(@a1, @a2))
        end

        it 'does not match nodes when an empty NodeSet is returned' do
          expect(evaluate_xpath(@document, 'root/a[id("foo")]')).to eq(node_set)
        end
      end
    end
  end
end
