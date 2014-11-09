require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'false() function' do
    before do
      @document = parse('')
    end

    example 'return false' do
      evaluate_xpath(@document, 'false()').should == false
    end
  end
end
