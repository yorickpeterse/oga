require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'string types' do
    before do
      @document = parse('')
    end

    it 'returns the literal string' do
      evaluate_xpath(@document, '"foo"').should == 'foo'
    end
  end
end
