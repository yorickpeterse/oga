require 'spec_helper'

describe Oga do
  it 'parses an XML document' do
    document = described_class.parse_xml('<root>foo</root>')

    document.is_a?(Oga::XML::Document).should == true
  end

  it 'parses an HTML document' do
    document = described_class.parse_xml('<html><body></body></html>')

    document.is_a?(Oga::XML::Document).should == true
  end

  describe 'SAX parsing' do
    before do
      klass = Class.new do
        attr_reader :name

        def on_element(namespace, name, attrs = {})
          @name = name
        end
      end

      @handler = klass.new
    end

    it 'parses an XML document using the SAX parser' do
      Oga.sax_parse_xml(@handler, '<foo />')

      @handler.name.should == 'foo'
    end

    it 'parses an HTML document using the SAX parser' do
      Oga.sax_parse_html(@handler, '<link>')

      @handler.name.should == 'link'
    end
  end
end
