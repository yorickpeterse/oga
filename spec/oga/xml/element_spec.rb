require 'spec_helper'

describe Oga::XML::Element do
  context 'setting attributes' do
    example 'set the name via the constructor' do
      described_class.new(:name => 'p').name.should == 'p'
    end

    example 'set the name via a setter' do
      instance = described_class.new
      instance.name = 'p'

      instance.name.should == 'p'
    end

    example 'set the default attributes' do
      described_class.new.attributes.should == {}
    end
  end

  context '#attribute' do
    before do
      @instance = described_class.new(:attributes => {:key => 'value'})
    end

    example 'return an attribute' do
      @instance.attribute('key').should == 'value'
    end
  end

  context '#text' do
    before do
      t1 = Oga::XML::Text.new(:text => 'Foo')
      t2 = Oga::XML::Text.new(:text => 'Bar')

      @n1 = described_class.new(:children => [t1])
      @n2 = described_class.new(:children => [@n1, t2])
    end

    example 'return the text of the parent node and its child nodes' do
      @n2.text.should == 'FooBar'
    end

    example 'return the text of the child node' do
      @n1.text.should == 'Foo'
    end
  end

  context '#to_xml' do
    example 'generate the corresponding XML' do
      described_class.new(:name => 'p').to_xml.should == '<p></p>'
    end

    example 'include the namespace if present' do
      instance = described_class.new(:name => 'p', :namespace => 'foo')

      instance.to_xml.should == '<foo:p></p>'
    end

    example 'include the attributes if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => {:key => 'value'}
      )

      instance.to_xml.should == '<p key="value"></p>'
    end

    example 'include the child nodes if present' do
      instance = described_class.new(
        :name     => 'p',
        :children => [Oga::XML::Comment.new(:text => 'foo')]
      )

      instance.to_xml.should == '<p><!--foo--></p>'
    end
  end

  context '#inspect' do
    before do
      children  = [Oga::XML::Comment.new(:text => 'foo')]
      @instance = described_class.new(
        :name       => 'p',
        :children   => children,
        :attributes => {'class' => 'foo'}
      )
    end

    example 'pretty-print the node' do
      @instance.inspect.should == <<-EOF.strip
Element(
  name: "p"
  namespace: nil
  attributes: {"class"=>"foo"}
  children: [
    Comment(text: "foo")
])
      EOF
    end
  end

  context '#type' do
    example 'return the type of the node' do
      described_class.new.node_type.should == :element
    end
  end
end
