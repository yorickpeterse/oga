require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'last() function' do
    before do
      @document = parse('<root><a>foo</a><a>bar</a></root>')

      @a2 = @document.children[0].children[1]
    end

    example 'return a node set containing the last node' do
      evaluate_xpath(@document, 'root/a[last()]').should == node_set(@a2)
    end
  end
end
