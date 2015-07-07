require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'string types' do
    before do
      @document = parse('')
    end

    it 'returns the literal string' do
      evaluate_xpath(@document, '"foo"').should == 'foo'
    end
  end
end
