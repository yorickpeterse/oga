require 'spec_helper'

describe Oga::XML::Attribute do
  describe '#initialize' do
    it 'sets the name' do
      described_class.new(:name => 'a').name.should == 'a'
    end

    it 'sets the value' do
      described_class.new(:value => 'a').value.should == 'a'
    end
  end

  describe '#namespace' do
    before do
      @namespace = Oga::XML::Namespace.new(:name => 'b')

      element = Oga::XML::Element.new(
        :namespaces => {'b' => @namespace}
      )

      @attribute = described_class.new(
        :namespace_name => 'b',
        :name           => 'a',
        :element        => element
      )

      @default = described_class.new(:namespace_name => 'xml', :name => 'x')
    end

    it 'returns a Namespace instance' do
      @attribute.namespace.should == @namespace
    end

    it 'returns the default XML namespace when the "xml" prefix is used' do
      @default.namespace.should == Oga::XML::DEFAULT_NAMESPACE
    end
  end

  describe '#text' do
    it 'returns an empty String when there is no value' do
      described_class.new.text.should == ''
    end

    it 'returns the value if it is present' do
      described_class.new(:value => 'a').text.should == 'a'
    end
  end

  describe '#to_xml' do
    it 'converts an attribute to XML' do
      attr = described_class.new(:name => 'foo', :value => 'bar')

      attr.to_xml.should == 'foo="bar"'
    end

    it 'includes the namespace when converting an attribute to XML' do
      element = Oga::XML::Element.new

      element.register_namespace('foo', 'http://foo')

      attr = described_class.new(
        :name           => 'class',
        :namespace_name => 'foo',
        :value          => '10',
        :element        => element
      )

      attr.to_xml.should == 'foo:class="10"'
    end

    it 'includes the "xmlns" namespace when present but not registered' do
      attr = described_class.new(
        :name           => 'class',
        :namespace_name => 'xmlns',
        :element        => Oga::XML::Element.new
      )

      attr.to_xml.should == 'xmlns:class=""'
    end

    it 'converts special characters to XML entities' do
      attr = described_class.new(:name => 'href', :value => '&<>')

      attr.to_xml.should == 'href="&amp;&lt;&gt;"'
    end
  end

  describe '#inspect' do
    it 'returns the inspect value' do
      element = Oga::XML::Element.new(
        :namespaces => {'b' => Oga::XML::Namespace.new(:name => 'b')}
      )

      obj = described_class.new(
        :namespace_name => 'b',
        :name           => 'a',
        :value          => 'c',
        :element        => element
      )

      obj.inspect.should == <<-EOF.strip
Attribute(name: "a" namespace: Namespace(name: "b" uri: nil) value: "c")
EOF
    end
  end
end
