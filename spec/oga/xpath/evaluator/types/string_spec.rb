require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'string types' do
    before do
      @document = parse('')
    end

    example 'return the literal string' do
      evaluate_xpath(@document, '"foo"').should == 'foo'
    end
  end
end
