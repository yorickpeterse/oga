require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'lang() function' do
    before do
      @document = parse('<root xml:lang="en"><a></a><a xml:lang="nl"></a></root>')

      @root = @document.children[0]
      @a1   = @root.children[0]
      @a2   = @root.children[1]
    end

    it 'returns a node set containing nodes with language "en"' do
      expect(evaluate_xpath(@document, 'root[lang("en")]')).to eq(node_set(@root))
    end

    it 'returns a node  set containing the nodes with language "nl"' do
      expect(evaluate_xpath(@document, 'root/a[lang("nl")]')).to eq(node_set(@a2))
    end

    it 'returns a node set containing the nodes with an inherited language' do
      expect(evaluate_xpath(@document, 'root/a[lang("en")]')).to eq(node_set(@a1))
    end
  end
end
