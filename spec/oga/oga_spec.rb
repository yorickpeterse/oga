require 'spec_helper'

describe Oga do
  example 'parse an XML document' do
    document = described_class.parse_xml('<root>foo</root>')

    document.is_a?(Oga::XML::Document).should == true
  end

  example 'parse an HTML document' do
    document = described_class.parse_xml('<html><body></body></html>')

    document.is_a?(Oga::XML::Document).should == true
  end

  context 'SAX parsing' do
    before do
      klass = Class.new do
        attr_reader :name

        def on_element(namespace, name, attrs = {})
          @name = name
        end
      end

      @handler = klass.new
    end

    example 'parse an XML document using the SAX parser' do
      Oga.sax_parse_xml(@handler, '<foo />')

      @handler.name.should == 'foo'
    end

    example 'parse an HTML document using the SAX parser' do
      Oga.sax_parse_xml(@handler, '<link>')

      @handler.name.should == 'link'
    end
  end
end
