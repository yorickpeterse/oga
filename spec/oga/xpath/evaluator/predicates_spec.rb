require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'predicates' do
    before do
      @document = parse('<root><b>10</b><b>20</b></root>')

      @b1 = @document.children[0].children[0]
      @b2 = @document.children[0].children[1]
    end

    example 'evaluate a predicate that returns the first <b> node' do
      evaluate_xpath(@document, 'root/b[1]').should == node_set(@b1)
    end

    example 'evaluate a predicate that returns the second <b> node' do
      evaluate_xpath(@document, 'root/b[2]').should == node_set(@b2)
    end
  end
end
