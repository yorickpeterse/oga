require 'spec_helper'

describe Oga::XML::Parser do
  context 'IO as input' do
    example 'parse an attribute starting with a newline' do
      io  = StringIO.new("<foo bar='\n10'></foo>")
      doc = parse(io)

      doc.children[0].attributes[0].value.should == "\n10"
    end

    example 'parse an attribute value split in two by a newline' do
      io  = StringIO.new("<foo bar='foo\nbar'></foo>")
      doc = parse(io)

      doc.children[0].attributes[0].value.should == "foo\nbar"
    end
  end
end
