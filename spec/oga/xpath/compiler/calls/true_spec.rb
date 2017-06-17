require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'true() function' do
    before do
      @document = parse('')
    end

    it 'returns true' do
      expect(evaluate_xpath(@document, 'true()')).to eq(true)
    end
  end
end
