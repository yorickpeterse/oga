require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'true() function' do
    before do
      @document = parse('')
    end

    it 'returns true' do
      evaluate_xpath(@document, 'true()').should == true
    end
  end
end
