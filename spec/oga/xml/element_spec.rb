require 'spec_helper'

describe Oga::XML::Element do
  describe '#initialize' do
    it 'sets the name via the constructor' do
      described_class.new(:name => 'p').name.should == 'p'
    end

    it 'sets the default attributes' do
      described_class.new.attributes.should == []
    end

    describe 'with a namespace' do
      before do
        attr = Oga::XML::Attribute.new(
          :name           => 'foo',
          :namespace_name => 'xmlns'
        )

        @element = described_class.new(:attributes => [attr])
      end

      it 'registers the "foo" namespace' do
        @element.namespaces['foo'].is_a?(Oga::XML::Namespace).should == true
      end

      it 'keeps the attributes after registering the namespaces' do
        @element.attributes.empty?.should == false
      end
    end

    describe 'with a default namespace' do
      before do
        attr = Oga::XML::Attribute.new(:name => 'xmlns', :value => 'foo')

        @element = described_class.new(:attributes => [attr])
      end

      it 'registers the default namespace' do
        @element.namespaces['xmlns'].is_a?(Oga::XML::Namespace).should == true
      end
    end
  end

  describe '#namespace_name=' do
    it 'sets the namepace name' do
      element = described_class.new(:name => 'a')

      element.namespace_name = 'foo'

      element.namespace_name.should == 'foo'
    end
  end

  describe '#attribute' do
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

    it 'returns an attribute with only a name' do
      @instance.attribute('key').value.should == 'value'
    end

    it 'returns an attribute with only a name when using a Symbol' do
      @instance.attribute(:key).value.should == 'value'
    end

    it 'returns an attribute with a name and namespace' do
      @instance.attribute('x:key').value.should == 'foo'
    end

    it 'returns an attribute with a name and namespace when using a Symbol' do
      @instance.attribute(:'x:key').value.should == 'foo'
    end

    it 'returns nil when the name matches but the namespace does not' do
      @instance.attribute('y:key').nil?.should == true
    end

    it 'returns nil when the namespace matches but the name does not' do
      @instance.attribute('x:foobar').nil?.should == true
    end

    it 'returns nil for a non existing attribute' do
      @instance.attribute('foobar').nil?.should == true
    end

    it 'returns nil if an attribute has a namespace that is not given' do
      @instance.attribute('bar').nil?.should == true
    end
  end

  describe '#get' do
    before do
      attr = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')

      @element = described_class.new(:attributes => [attr])
    end

    it 'returns the value of an attribute' do
      @element.get('foo').should == 'bar'
    end
  end

  describe '#add_attribute' do
    before do
      @element   = described_class.new
      @attribute = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')
    end

    it 'adds an Attribute to the element' do
      @element.add_attribute(@attribute)

      @element.attribute('foo').should == @attribute
    end

    it 'sets the element of the attribute when adding it' do
      @element.add_attribute(@attribute)

      @attribute.element.should == @element
    end
  end

  describe '#set' do
    before do
      @element = described_class.new

      @element.register_namespace('x', 'test')
    end

    it 'adds a new attribute' do
      @element.set('class', 'foo')

      @element.get('class').should == 'foo'
    end

    it 'adds a new attribute with a namespace' do
      @element.set('x:bar', 'foo')

      @element.get('x:bar').should == 'foo'
    end

    it 'sets the namespace of an attribute' do
      @element.set('x:bar', 'foo')

      attr = @element.attribute('x:bar')

      attr.namespace.is_a?(Oga::XML::Namespace).should == true
    end

    it 'overwrites the value of an existing attribute' do
      attr = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')

      @element.add_attribute(attr)

      @element.set('foo', 'baz')

      @element.get('foo').should == 'baz'
    end
  end

  describe '#unset' do
    before do
      @element = described_class.new

      @element.register_namespace('x', 'test')

      @element.set('foo', 'bar')
      @element.set('x:foo', 'bar')
    end

    it 'removes an attribute by its name' do
      @element.unset('foo')

      @element.get('foo').should be_nil
    end

    it 'removes an attribute using a namespace' do
      @element.unset('x:foo')

      @element.get('x:foo').should be_nil
    end
  end

  describe '#namespace' do
    it 'returns the namespace' do
      namespace = Oga::XML::Namespace.new(:name => 'x')
      element   = described_class.new(
        :namespace_name => 'x',
        :namespaces     => {'x' => namespace}
      )

      element.namespace.should == namespace
    end

    it 'returns the default namespace if available' do
      namespace = Oga::XML::Namespace.new(:name => 'xmlns')
      element   = described_class.new(
        :namespaces => {'xmlns' => namespace}
      )

      element.namespace.should == namespace
    end

    it 'flushes the cache when changing the namespace name' do
      namespace = Oga::XML::Namespace.new(:name => 'bar')
      element   = described_class.new(
        :namespaces => {'bar' => namespace}
      )

      element.namespace_name = 'foo'

      element.namespace.should be_nil
    end

    describe 'in an HTML document' do
      it 'returns nil' do
        ns  = Oga::XML::Namespace.new(:name => 'xmlns')
        el  = described_class.new(:namespaces => {'xmlns' => ns})
        doc = Oga::XML::Document.new(:type => :html, :children => [el])

        el.namespace.should be_nil
      end
    end
  end

  describe '#namespaces' do
    it 'returns the registered namespaces as a Hash' do
      namespace = Oga::XML::Namespace.new(:name => 'x')
      element   = described_class.new(
        :namespace_name => 'x',
        :namespaces     => {'x' => namespace}
      )

      element.namespaces.should == {'x' => namespace}
    end

    describe 'in an HTML document' do
      it 'returns an empty Hash' do
        ns  = Oga::XML::Namespace.new(:name => 'xmlns')
        el  = described_class.new(:namespaces => {'xmlns' => ns})
        doc = Oga::XML::Document.new(:type => :html, :children => [el])

        el.namespaces.should == {}
      end
    end
  end

  describe '#default_namespace?' do
    it 'returns true when an element has no explicit namespace' do
      described_class.new(:name => 'a').default_namespace?.should == true
    end

    it 'returns true when an element has an explicit default namespace' do
      element   = described_class.new(:name => 'a')
      namespace = Oga::XML::DEFAULT_NAMESPACE

      element.register_namespace(namespace.name, namespace.uri)

      element.default_namespace?.should == true
    end

    it 'returns false when an element resides in a custom namespace' do
      element = described_class.new(:name => 'a')

      element.register_namespace('xmlns', 'foo')

      element.default_namespace?.should == false
    end
  end

  describe '#text' do
    before do
      t1 = Oga::XML::Text.new(:text => 'Foo')
      t2 = Oga::XML::Text.new(:text => 'Bar')

      @n1 = described_class.new(:children => [t1])
      @n2 = described_class.new(:children => [@n1, t2])
    end

    it 'returns the text of the parent node and its child nodes' do
      @n2.text.should == 'FooBar'
    end

    it 'returns the text of the child node' do
      @n1.text.should == 'Foo'
    end
  end

  describe '#inner_text' do
    before do
      t1 = Oga::XML::Text.new(:text => 'Foo')
      t2 = Oga::XML::Text.new(:text => 'Bar')

      @n1 = described_class.new(:children => [t1])
      @n2 = described_class.new(:children => [@n1, t2])
    end

    it 'returns the inner text of the parent node' do
      @n2.inner_text.should == 'Bar'
    end

    it 'returns the inner text of the child node' do
      @n1.inner_text.should == 'Foo'
    end
  end

  describe '#inner_text=' do
    before do
      @element = described_class.new
    end

    it 'sets the inner text of an element' do
      @element.inner_text = 'foo'
      @element.inner_text.should == 'foo'
    end

    it 'removes all existing nodes before inserting a new text node' do
      @element.children << Oga::XML::Text.new(:text => 'foo')
      @element.children << Oga::XML::Element.new(:name => 'x')

      @element.inner_text = 'bar'

      @element.children.length.should == 1
    end

    it 'sets the parent node of the newly inserted text node' do
      @element.inner_text = 'foo'

      @element.children[0].parent.should == @element
    end
  end

  describe '#text_nodes' do
    before do
      @t1 = Oga::XML::Text.new(:text => 'Foo')
      @t2 = Oga::XML::Text.new(:text => 'Bar')

      @element = described_class.new(:children => [@t1, @t2])
    end

    it 'returns a node set containing the text nodes' do
      @element.text_nodes.should == node_set(@t1, @t2)
    end
  end

  describe '#to_xml' do
    it 'generates the corresponding XML' do
      described_class.new(:name => 'p').to_xml.should == '<p />'
    end

    it 'includes the namespace if present' do
      instance = described_class.new(
        :name           => 'p',
        :namespace_name => 'foo',
        :namespaces     => {'foo' => Oga::XML::Namespace.new(:name => 'foo')},
        :children       => [Oga::XML::Text.new(:text => 'Foo')]
      )

      instance.to_xml.should == '<foo:p>Foo</foo:p>'
    end

    it 'includes a single attribute if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => [
          Oga::XML::Attribute.new(:name => 'key', :value => 'value')
        ]
      )

      instance.to_xml.should == '<p key="value" />'
    end

    it 'includes multiple attributes if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => [
          Oga::XML::Attribute.new(:name => 'key1', :value => 'value1'),
          Oga::XML::Attribute.new(:name => 'key2', :value => 'value2'),
        ]
      )

      instance.to_xml.should == '<p key1="value1" key2="value2" />'
    end

    it 'includes the child nodes if present' do
      instance = described_class.new(
        :name     => 'p',
        :children => [Oga::XML::Comment.new(:text => 'foo')]
      )

      instance.to_xml.should == '<p><!--foo--></p>'
    end

    it 'generates the corresponding XML when using a default namespace' do
      namespace = Oga::XML::Namespace.new(:name => 'xmlns', :uri => 'foo')
      instance  = described_class.new(
        :name       => 'foo',
        :namespaces => {'xmlns' => namespace}
      )

      instance.to_xml.should == '<foo />'
    end

    it 'generates the XML for the HTML <script> element' do
      element  = described_class.new(:name => 'script')
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      element.to_xml.should == '<script></script>'
    end

    it 'generates the XML for the HTML <link> element' do
      element  = described_class.new(:name => 'link')
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      element.to_xml.should == '<link />'
    end
  end

  describe '#inspect' do
    it 'inspects a node with a name' do
      node = described_class.new(:name => 'a')

      node.inspect.should == 'Element(name: "a")'
    end

    it 'inspects a node with attributes and children' do
      node = described_class.new(
        :name       => 'p',
        :children   => [Oga::XML::Comment.new(:text => 'foo')],
        :attributes => [Oga::XML::Attribute.new(:name => 'x', :value => 'y')]
      )

      node.inspect.should == 'Element(name: "p" attributes: ' \
        '[Attribute(name: "x" value: "y")] children: NodeSet(Comment("foo")))'
    end

    it 'inspects a node with a namespace' do
      node = described_class.new(
        :name           => 'p',
        :namespace_name => 'x',
        :namespaces     => {'x' => Oga::XML::Namespace.new(:name => 'x')}
      )

      node.inspect.should == 'Element(name: "p" ' \
        'namespace: Namespace(name: "x" uri: nil))'
    end
  end

  describe '#register_namespace' do
    before do
      @element = described_class.new

      @element.register_namespace('foo', 'http://example.com')
    end

    it 'returns a Namespace instance' do
      @element.namespaces['foo'].is_a?(Oga::XML::Namespace).should == true
    end

    it 'sets the name of the namespace' do
      @element.namespaces['foo'].name.should == 'foo'
    end

    it 'sets the URI of the namespace' do
      @element.namespaces['foo'].uri.should == 'http://example.com'
    end

    it 'raises ArgumentError if the namespace already exists' do
      block = lambda { @element.register_namespace('foo', 'bar') }

      block.should raise_error(ArgumentError)
    end
  end

  describe '#available_namespaces' do
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

    it 'inherits the "foo" namespace from the parent' do
      @child_ns['foo'].uri.should == 'bar'
    end

    it 'overwrites the "baz" namespace in the child' do
      @child_ns['baz'].uri.should == 'xxx'
    end

    it 'returns the "foo" namespace for the parent' do
      @parent_ns['foo'].uri.should == 'bar'
    end

    it 'returns the "baz" namespace for the parent' do
      @parent_ns['baz'].uri.should == 'yyy'
    end

    it 'does not modify the list of direct namespaces' do
      @child.namespaces.key?('foo').should == false
    end

    describe 'in an HTML document' do
      it 'returns an empty Hash' do
        ns  = Oga::XML::Namespace.new(:name => 'xmlns')
        el  = described_class.new(:namespaces => {'xmlns' => ns})
        doc = Oga::XML::Document.new(:type => :html, :children => [el])

        el.available_namespaces.should == {}
      end
    end
  end

  describe '#self_closing?' do
    it 'returns true for an empty XML element' do
      described_class.new(:name => 'foo').should be_self_closing
    end

    it 'returns false for a non empty XML element' do
      text = Oga::XML::Text.new(:text => 'bar')
      node = described_class.new(:name => 'foo', :children => [text])

      node.should_not be_self_closing
    end

    it 'returns true for an HTML void element' do
      element  = described_class.new(:name => 'link')
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      element.should be_self_closing
    end

    it 'returns false for a non empty HTML element' do
      text     = Oga::XML::Text.new(:text => 'alert()')
      element  = described_class.new(:name => 'script', :children => [text])
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      element.should_not be_self_closing
    end
  end
end
