require 'spec_helper'

describe Oga::XML::Parser do
  describe 'raising syntax errors' do
    before do
      @invalid_xml = '<x:y:z></z>'
    end

    it 'raises a LL::ParserError' do
      expect { parse(@invalid_xml) }.to raise_error(LL::ParserError)
    end

    it 'includes the line number when using a String as input' do
      expect(parse_error(@invalid_xml)).to match(/on line 1/)
    end

    it 'includes the line number when using an IO as input' do
      expect(parse_error(StringIO.new(@invalid_xml))).to match(/on line 1/)
    end

    it 'uses more friendly error messages when available' do
      expect(parse_error('<x:y:z>')).to match(/Unexpected element namespace/)
    end
  end
end
