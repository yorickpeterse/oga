require 'spec_helper'

describe Oga do
  context 'parse_xml' do
    example 'parse an XML document' do
      document = described_class.parse_xml('<root>foo</root>')

      document.is_a?(Oga::XML::Document).should == true
    end
  end

  context 'parse_html' do
    example 'parse an HTML document' do
      document = described_class.parse_xml('<html><body></body></html>')

      document.is_a?(Oga::XML::Document).should == true
    end
  end
end
