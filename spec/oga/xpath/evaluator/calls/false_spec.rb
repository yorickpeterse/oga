require 'spec_helper'

describe Oga::XPath::Evaluator do
  describe 'false() function' do
    before do
      @document = parse('')
    end

    it 'returns false' do
      evaluate_xpath(@document, 'false()').should == false
    end
  end
end
