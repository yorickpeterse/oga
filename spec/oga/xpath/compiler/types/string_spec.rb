require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'string types' do
    before do
      @document = parse('')
    end

    it 'returns the literal string' do
      expect(evaluate_xpath(@document, '"foo"')).to eq('foo')
    end
  end
end
