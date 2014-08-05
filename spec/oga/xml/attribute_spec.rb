require 'spec_helper'

describe Oga::XML::Attribute do
  context '#initialize' do
    example 'set the name' do
      described_class.new(:name => 'a').name.should == 'a'
    end

    example 'set the namespace' do
      described_class.new(:namespace => 'a').namespace.should == 'a'
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
      obj = described_class.new(:name => 'a', :namespace => 'b', :value => 'c')

      obj.inspect.should == 'Attribute(name: "a" namespace: "b" value: "c")'
    end
  end
end
