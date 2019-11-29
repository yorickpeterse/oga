require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<root xmlns:x="y"><x:a></x:a><b x:num="10"></b></root>')
    @root = @document.children[0]
    @a = @root.children[0]
    @b = @root.children[1]
    @attr = @b.attributes[0]
    @namespaces = {
      "n" => "y"
    }
  end

  describe 'with custom namespace aliases' do
    it 'uses aliases when querying an element' do
      expect(evaluate_xpath(@document, 'root/n:a', namespaces: @namespaces)).to eq(node_set(@a))
    end

    it "doesn't use namespaces in XPath expression when querying an element" do
      expect(evaluate_xpath(@document, 'root/x:a', namespaces: @namespaces)).to eq(node_set)
    end

    it 'uses aliases when querying an attribute' do
      expect(evaluate_xpath(@document, 'root/b/@n:num', namespaces: @namespaces)).to eq(node_set(@attr))
    end

    it "doesn't use namespaces in XPath expression when querying an attribute" do
      expect(evaluate_xpath(@document, 'root/b/@x:num', namespaces: @namespaces)).to eq(node_set)
    end

    it 'uses aliases when querying an element with a namespaced attribute' do
      expect(evaluate_xpath(@document, 'root/b[@n:num]', namespaces: @namespaces)).to eq(node_set(@b))
    end

    it "doesn't use namespaces in XPath expression when querying an element with a namespaced attribute" do
      expect(evaluate_xpath(@document, 'root/b[@x:num]', namespaces: @namespaces)).to eq(node_set)
    end
  end
end
