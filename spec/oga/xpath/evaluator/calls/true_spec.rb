require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'true() function' do
    before do
      @document = parse('')
    end

    example 'return true' do
      evaluate_xpath(@document, 'true()').should == true
    end
  end
end
