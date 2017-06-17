require 'spec_helper'

describe Oga::XML::Parser do
  describe 'IO as input' do
    it 'parses an attribute starting with a newline' do
      io  = StringIO.new("<foo bar='\n10'></foo>")
      doc = parse(io)

      expect(doc.children[0].attributes[0].value).to eq("\n10")
    end

    it 'parses an attribute value split in two by a newline' do
      io  = StringIO.new("<foo bar='foo\nbar'></foo>")
      doc = parse(io)

      expect(doc.children[0].attributes[0].value).to eq("foo\nbar")
    end
  end
end
