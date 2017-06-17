require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'false() function' do
    before do
      @document = parse('')
    end

    it 'returns false' do
      expect(evaluate_xpath(@document, 'false()')).to eq(false)
    end
  end
end
