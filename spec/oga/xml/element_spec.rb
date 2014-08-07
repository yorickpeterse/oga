require 'spec_helper'

describe Oga::XML::Element do
  context 'setting attributes' do
    example 'set the name via the constructor' do
      described_class.new(:name => 'p').name.should == 'p'
    end

    example 'raise TypeError when the namespace is a String' do
      block = lambda { described_class.new(:namespace => 'x') }

      block.should raise_error(TypeError)
    end

    example 'set the name via a setter' do
      instance = described_class.new
      instance.name = 'p'

      instance.name.should == 'p'
    end

    example 'set the default attributes' do
      described_class.new.attributes.should == []
    end
  end

  context '#attribute' do
    before do
      attributes = [
        Oga::XML::Attribute.new(:name => 'key', :value => 'value'),
        Oga::XML::Attribute.new(
          :name      => 'key',
          :value     => 'foo',
          :namespace => Oga::XML::Namespace.new(:name => 'x')
        )
      ]

      @instance = described_class.new(:attributes => attributes)
    end

    example 'return an attribute with only a name' do
      @instance.attribute('key').value.should == 'value'
    end

    example 'return an attribute with only a name when using a Symbol' do
      @instance.attribute(:key).value.should == 'value'
    end

    example 'return an attribute with a name and namespace' do
      @instance.attribute('x:key').value.should == 'foo'
    end

    example 'return an attribute with a name and namespace when using a Symbol' do
      @instance.attribute(:'x:key').value.should == 'foo'
    end

    example 'return nil when the name matches but the namespace does not' do
      @instance.attribute('y:key').nil?.should == true
    end

    example 'return nil when the namespace matches but the name does not' do
      @instance.attribute('x:foobar').nil?.should == true
    end

    example 'return nil for a non existing attribute' do
      @instance.attribute('foobar').nil?.should == true
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

  context '#inner_text' do
    before do
      t1 = Oga::XML::Text.new(:text => 'Foo')
      t2 = Oga::XML::Text.new(:text => 'Bar')

      @n1 = described_class.new(:children => [t1])
      @n2 = described_class.new(:children => [@n1, t2])
    end

    example 'return the inner text of the parent node' do
      @n2.inner_text.should == 'Bar'
    end

    example 'return the inner text of the child node' do
      @n1.inner_text.should == 'Foo'
    end
  end

  context '#to_xml' do
    example 'generate the corresponding XML' do
      described_class.new(:name => 'p').to_xml.should == '<p></p>'
    end

    example 'include the namespace if present' do
      instance = described_class.new(
        :name      => 'p',
        :namespace => Oga::XML::Namespace.new(:name => 'foo')
      )

      instance.to_xml.should == '<foo:p></foo:p>'
    end

    example 'include the attributes if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => [
          Oga::XML::Attribute.new(:name => 'key', :value => 'value')
        ]
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
    example 'inspect a node with a name' do
      node = described_class.new(:name => 'a')

      node.inspect.should == <<-EOF.strip
Element(
  name: "a"
  children: [

])
      EOF
    end

    example 'inspect a node with attributes and children' do
      node = described_class.new(
        :name       => 'p',
        :children   => [Oga::XML::Comment.new(:text => 'foo')],
        :attributes => {'class' => 'foo'}
      )

      node.inspect.should == <<-EOF.strip
Element(
  name: "p"
  attributes: {"class"=>"foo"}
  children: [
    Comment(text: "foo")
])
      EOF
    end

    example 'inspect a node with a namespace' do
      node = described_class.new(
        :name      => 'p',
        :namespace => Oga::XML::Namespace.new(:name => 'x')
      )

      node.inspect.should == <<-EOF.strip
Element(
  name: "p"
  namespace: Namespace(name: "x")
  children: [

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
