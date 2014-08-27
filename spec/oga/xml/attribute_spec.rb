require 'spec_helper'

describe Oga::XML::Attribute do
  context '#initialize' do
    example 'set the name' do
      described_class.new(:name => 'a').name.should == 'a'
    end

    example 'set the value' do
      described_class.new(:value => 'a').value.should == 'a'
    end
  end

  context '#namespace' do
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

    example 'return a Namespace instance' do
      @attribute.namespace.should == @namespace
    end

    example 'return the default XML namespace when the "xml" prefix is used' do
      @default.namespace.should == Oga::XML::Attribute::DEFAULT_NAMESPACE
    end
  end

  context '#to_s' do
    example 'return an empty String when there is no value' do
      described_class.new.to_s.should == ''
    end

    example 'return the value if it is present' do
      described_class.new(:value => 'a').to_s.should == 'a'
    end
  end

  context '#to_xml' do
    example 'return a key/value pair for an XML document' do
      attr = described_class.new(:name => 'foo', :value => 'bar')

      attr.to_xml.should == 'foo="bar"'
    end
  end

  context '#inspect' do
    example 'return the inspect value' do
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
