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
      described_class.new.attributes.should == []
    end
  end

  context 'setting namespaces via attributes' do
    before do
      attr = Oga::XML::Attribute.new(:name => 'foo', :namespace_name => 'xmlns')

      @element = described_class.new(:attributes => [attr])
    end

    example 'register the "foo" namespace' do
      @element.namespaces['foo'].is_a?(Oga::XML::Namespace).should == true
    end

    example 'remove the namespace attribute from the list of attributes' do
      @element.attributes.empty?.should == true
    end
  end

  context 'setting the default namespace without a prefix' do
    before do
      attr = Oga::XML::Attribute.new(:name => 'xmlns', :value => 'foo')

      @element = described_class.new(:attributes => [attr])
    end

    example 'register the default namespace' do
      @element.namespaces['xmlns'].is_a?(Oga::XML::Namespace).should == true
    end

    example 'remove the namespace attribute from the list of attributes' do
      @element.attributes.empty?.should == true
    end
  end

  context '#attribute' do
    before do
      attributes = [
        Oga::XML::Attribute.new(:name => 'key', :value => 'value'),
        Oga::XML::Attribute.new(
          :name           => 'bar',
          :value          => 'baz',
          :namespace_name => 'x'
        ),
        Oga::XML::Attribute.new(
          :name           => 'key',
          :value          => 'foo',
          :namespace_name => 'x'
        )
      ]

      @instance = described_class.new(
        :attributes => attributes,
        :namespaces => {'x' => Oga::XML::Namespace.new(:name => 'x')}
      )
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

    example 'return nil if an attribute has a namespace that is not given' do
      @instance.attribute('bar').nil?.should == true
    end
  end

  context '#get' do
    before do
      attr = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')

      @element = described_class.new(:attributes => [attr])
    end

    example 'return the value of an attribute' do
      @element.get('foo').should == 'bar'
    end
  end

  context '#add_attribute' do
    before do
      @element   = described_class.new
      @attribute = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')
    end

    example 'add an Attribute to the element' do
      @element.add_attribute(@attribute)

      @element.attribute('foo').should == @attribute
    end

    example 'set the element of the attribute when adding it' do
      @element.add_attribute(@attribute)

      @attribute.element.should == @element
    end
  end

  context '#set' do
    before do
      @element = described_class.new

      @element.register_namespace('x', 'test')
    end

    example 'add a new attribute' do
      @element.set('class', 'foo')

      @element.get('class').should == 'foo'
    end

    example 'add a new attribute with a namespace' do
      @element.set('x:bar', 'foo')

      @element.get('x:bar').should == 'foo'
    end

    example 'set the namespace of an attribute' do
      @element.set('x:bar', 'foo')

      attr = @element.attribute('x:bar')

      attr.namespace.is_a?(Oga::XML::Namespace).should == true
    end

    example 'overwrite the value of an existing attribute' do
      attr = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')

      @element.add_attribute(attr)

      @element.set('foo', 'baz')

      @element.get('foo').should == 'baz'
    end
  end

  context '#namespace' do
    example 'return the namespace' do
      namespace = Oga::XML::Namespace.new(:name => 'x')
      element   = described_class.new(
        :namespace_name => 'x',
        :namespaces     => {'x' => namespace}
      )

      element.namespace.should == namespace
    end

    example 'return the default namespace if available' do
      namespace = Oga::XML::Namespace.new(:name => 'xmlns')
      element   = described_class.new(
        :namespaces => {'xmlns' => namespace}
      )

      element.namespace.should == namespace
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

  context '#inner_text=' do
    before do
      @element = described_class.new
    end

    example 'set the inner text of an element' do
      @element.inner_text = 'foo'
      @element.inner_text.should == 'foo'
    end

    example 'remove existing text nodes before inserting new nodes' do
      @element.children << Oga::XML::Text.new(:text => 'foo')

      @element.inner_text = 'bar'
      @element.inner_text.should == 'bar'
    end
  end

  context '#text_nodes' do
    before do
      @t1     = Oga::XML::Text.new(:text => 'Foo')
      @t2     = Oga::XML::Text.new(:text => 'Bar')
      element = described_class.new(:children => [@t1, @t2])

      @set = element.text_nodes
    end

    it_behaves_like :node_set, :length => 2

    example 'return the first Text node' do
      @set[0].should == @t1
    end

    example 'return the second Text node' do
      @set[1].should == @t2
    end
  end

  context '#to_xml' do
    example 'generate the corresponding XML' do
      described_class.new(:name => 'p').to_xml.should == '<p></p>'
    end

    example 'include the namespace if present' do
      instance = described_class.new(
        :name           => 'p',
        :namespace_name => 'foo',
        :namespaces     => {'foo' => Oga::XML::Namespace.new(:name => 'foo')}
      )

      instance.to_xml.should == '<foo:p></foo:p>'
    end

    example 'include a single attribute if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => [
          Oga::XML::Attribute.new(:name => 'key', :value => 'value')
        ]
      )

      instance.to_xml.should == '<p key="value"></p>'
    end

    example 'include multiple attributes if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => [
          Oga::XML::Attribute.new(:name => 'key1', :value => 'value1'),
          Oga::XML::Attribute.new(:name => 'key2', :value => 'value2'),
        ]
      )

      instance.to_xml.should == '<p key1="value1" key2="value2"></p>'
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

      node.inspect.should == 'Element(name: "a")'
    end

    example 'inspect a node with attributes and children' do
      node = described_class.new(
        :name       => 'p',
        :children   => [Oga::XML::Comment.new(:text => 'foo')],
        :attributes => [Oga::XML::Attribute.new(:name => 'x', :value => 'y')]
      )

      node.inspect.should == 'Element(name: "p" attributes: ' \
        '[Attribute(name: "x" value: "y")] children: NodeSet(Comment("foo")))'
    end

    example 'inspect a node with a namespace' do
      node = described_class.new(
        :name           => 'p',
        :namespace_name => 'x',
        :namespaces     => {'x' => Oga::XML::Namespace.new(:name => 'x')}
      )

      node.inspect.should == 'Element(name: "p" ' \
        'namespace: Namespace(name: "x" uri: nil))'
    end
  end

  context '#register_namespace' do
    before do
      @element = described_class.new

      @element.register_namespace('foo', 'http://example.com')
    end

    example 'return a Namespace instance' do
      @element.namespaces['foo'].is_a?(Oga::XML::Namespace).should == true
    end

    example 'set the name of the namespace' do
      @element.namespaces['foo'].name.should == 'foo'
    end

    example 'set the URI of the namespace' do
      @element.namespaces['foo'].uri.should == 'http://example.com'
    end

    example 'raise ArgumentError if the namespace already exists' do
      block = lambda { @element.register_namespace('foo', 'bar') }

      block.should raise_error(ArgumentError)
    end
  end

  context '#available_namespaces' do
    before do
      @parent = described_class.new
      @child  = described_class.new

      @child.node_set = Oga::XML::NodeSet.new([@child], @parent)

      @parent.register_namespace('foo', 'bar')
      @parent.register_namespace('baz', 'yyy')

      @child.register_namespace('baz', 'xxx')

      @parent_ns = @parent.available_namespaces
      @child_ns  = @child.available_namespaces
    end

    example 'inherit the "foo" namespace from the parent' do
      @child_ns['foo'].uri.should == 'bar'
    end

    example 'overwrite the "baz" namespace in the child' do
      @child_ns['baz'].uri.should == 'xxx'
    end

    example 'return the "foo" namespace for the parent' do
      @parent_ns['foo'].uri.should == 'bar'
    end

    example 'return the "baz" namespace for the parent' do
      @parent_ns['baz'].uri.should == 'yyy'
    end
  end
end
