require 'spec_helper'

describe Oga::XML::Attribute do
  context '#initialize' do
    example 'set the name' do
      described_class.new(:name => 'a').name.should == 'a'
    end

    example 'set the namespace' do
      ns   = Oga::XML::Namespace.new(:name => 'foo')
      attr = described_class.new(:namespace => ns)

      attr.namespace.should == ns
    end

    example 'raise TypeError when using a String for the namespace' do
      block = lambda { described_class.new(:namespace => 'x') }

      block.should raise_error(TypeError)
    end

    example 'set the value' do
      described_class.new(:value => 'a').value.should == 'a'
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
      obj = described_class.new(
        :name      => 'a',
        :namespace => Oga::XML::Namespace.new(:name => 'b'),
        :value     => 'c'
      )

      obj.inspect.should == <<-EOF.strip
Attribute(name: "a" namespace: Namespace(name: "b") value: "c")
EOF
    end
  end
end
