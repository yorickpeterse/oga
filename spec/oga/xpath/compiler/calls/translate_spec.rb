require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'translate() function' do
    before do
      @document = parse('<root><a>bar</a><b>abc</b><c>ABC</c></root>')
    end

    it 'translates a string using all string literals' do
      expect(evaluate_xpath(@document, 'translate("bar", "abc", "ABC")'))
        .to eq('BAr')
    end

    it "removes characters that don't occur in the replacement string" do
      expect(evaluate_xpath(@document, 'translate("-aaa-", "abc-", "ABC")'))
        .to eq('AAA')
    end

    it 'uses the first character occurence in the search string' do
      expect(evaluate_xpath(@document, 'translate("ab", "aba", "123")')).to eq('12')
    end

    it 'ignores excess characters in the replacement string' do
      expect(evaluate_xpath(@document, 'translate("abc", "abc", "123456")'))
        .to eq('123')
    end

    it 'translates a node set string using string literals' do
      expect(evaluate_xpath(@document, 'translate(root/a, "abc", "ABC")'))
        .to eq('BAr')
    end

    it 'translates a node set string using other node set strings' do
      expect(evaluate_xpath(@document, 'translate(root/a, root/b, root/c)'))
        .to eq('BAr')
    end
  end
end
