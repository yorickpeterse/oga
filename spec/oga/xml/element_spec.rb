require 'spec_helper'

describe Oga::XML::Element do
  describe '#initialize' do
    it 'sets the name via the constructor' do
      expect(described_class.new(:name => 'p').name).to eq('p')
    end

    it 'sets the default attributes' do
      expect(described_class.new.attributes).to eq([])
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
        expect(@element.namespaces['foo'].is_a?(Oga::XML::Namespace)).to eq(true)
      end

      it 'keeps the attributes after registering the namespaces' do
        expect(@element.attributes.empty?).to eq(false)
      end
    end

    describe 'with a default namespace' do
      before do
        attr = Oga::XML::Attribute.new(:name => 'xmlns', :value => 'foo')

        @element = described_class.new(:attributes => [attr])
      end

      it 'registers the default namespace' do
        expect(@element.namespaces['xmlns'].is_a?(Oga::XML::Namespace)).to eq(true)
      end
    end
  end

  describe '#namespace_name=' do
    it 'sets the namepace name' do
      element = described_class.new(:name => 'a')

      element.namespace_name = 'foo'

      expect(element.namespace_name).to eq('foo')
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
      expect(@instance.attribute('key').value).to eq('value')
    end

    it 'returns an attribute with only a name when using a Symbol' do
      expect(@instance.attribute(:key).value).to eq('value')
    end

    it 'returns an attribute with a name and namespace' do
      expect(@instance.attribute('x:key').value).to eq('foo')
    end

    it 'returns an attribute with a name and namespace when using a Symbol' do
      expect(@instance.attribute(:'x:key').value).to eq('foo')
    end

    it 'returns nil when the name matches but the namespace does not' do
      expect(@instance.attribute('y:key').nil?).to eq(true)
    end

    it 'returns nil when the namespace matches but the name does not' do
      expect(@instance.attribute('x:foobar').nil?).to eq(true)
    end

    it 'returns nil for a non existing attribute' do
      expect(@instance.attribute('foobar').nil?).to eq(true)
    end

    it 'returns nil if an attribute has a namespace that is not given' do
      expect(@instance.attribute('bar').nil?).to eq(true)
    end

    describe 'using an HTML document' do
      let(:attr) do
        Oga::XML::Attribute.new(name: 'foo:bar', value: 'foo')
      end

      let(:el) do
        el = described_class.new(name: 'foo', attributes: [attr])
        Oga::XML::Document.new(children: [el], type: :html)

        el
      end

      it 'returns an attribute with a name containing a namespace separator' do
        expect(el.attribute('foo:bar')).to eq(attr)
      end

      describe 'using a Symbol argument' do
        it 'returns the attribute' do
          expect(el.attribute(:'foo:bar')).to eq(attr)
        end
      end
    end
  end

  describe '#get' do
    before do
      attr = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')

      @element = described_class.new(:attributes => [attr])
    end

    it 'returns the value of an attribute' do
      expect(@element.get('foo')).to eq('bar')
    end
  end

  describe '#[]' do
    it 'is an alias to get' do
      expect(described_class.instance_method(:[])).to eq(
        described_class.instance_method(:get)
      )
    end
  end

  describe '#add_attribute' do
    before do
      @element   = described_class.new
      @attribute = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')
    end

    it 'adds an Attribute to the element' do
      @element.add_attribute(@attribute)

      expect(@element.attribute('foo')).to eq(@attribute)
    end

    it 'sets the element of the attribute when adding it' do
      @element.add_attribute(@attribute)

      expect(@attribute.element).to eq(@element)
    end
  end

  describe '#set' do
    before do
      @element = described_class.new

      @element.register_namespace('x', 'test')
    end

    it 'adds a new attribute' do
      @element.set('class', 'foo')

      expect(@element.get('class')).to eq('foo')
    end

    it 'supports the use of Symbols for attribute names' do
      @element.set(:foo, 'foo')
      expect(@element.get('foo')).to eq('foo')

      @element.set('bar', 'bar')
      expect(@element.get(:bar)).to eq('bar')
    end

    it 'adds a new attribute with a namespace' do
      @element.set('x:bar', 'foo')

      expect(@element.get('x:bar')).to eq('foo')
    end

    it 'sets the namespace of an attribute' do
      @element.set('x:bar', 'foo')

      attr = @element.attribute('x:bar')

      expect(attr.namespace.is_a?(Oga::XML::Namespace)).to eq(true)
    end

    it 'overwrites the value of an existing attribute' do
      attr = Oga::XML::Attribute.new(:name => 'foo', :value => 'bar')

      @element.add_attribute(attr)

      @element.set('foo', 'baz')

      expect(@element.get('foo')).to eq('baz')
    end
  end

  describe '#[]=' do
    it 'is an alias to set' do
      expect(described_class.instance_method(:[]=)).to eq(
        described_class.instance_method(:set)
      )
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

      expect(@element.get('foo')).to be_nil
    end

    it 'removes an attribute using a namespace' do
      @element.unset('x:foo')

      expect(@element.get('x:foo')).to be_nil
    end
  end

  describe '#namespace' do
    it 'returns the namespace' do
      namespace = Oga::XML::Namespace.new(:name => 'x')
      element   = described_class.new(
        :namespace_name => 'x',
        :namespaces     => {'x' => namespace}
      )

      expect(element.namespace).to eq(namespace)
    end

    it 'returns the default namespace if available' do
      namespace = Oga::XML::Namespace.new(:name => 'xmlns')
      element   = described_class.new(
        :namespaces => {'xmlns' => namespace}
      )

      expect(element.namespace).to eq(namespace)
    end

    it 'flushes the cache when changing the namespace name' do
      namespace = Oga::XML::Namespace.new(:name => 'bar')
      element   = described_class.new(
        :namespaces => {'bar' => namespace}
      )

      element.namespace_name = 'foo'

      expect(element.namespace).to be_nil
    end

    describe 'in an HTML document' do
      it 'returns nil' do
        ns  = Oga::XML::Namespace.new(:name => 'xmlns')
        el  = described_class.new(:namespaces => {'xmlns' => ns})
        doc = Oga::XML::Document.new(:type => :html, :children => [el])

        expect(el.namespace).to be_nil
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

      expect(element.namespaces).to eq({'x' => namespace})
    end

    describe 'in an HTML document' do
      it 'returns an empty Hash' do
        ns  = Oga::XML::Namespace.new(:name => 'xmlns')
        el  = described_class.new(:namespaces => {'xmlns' => ns})
        doc = Oga::XML::Document.new(:type => :html, :children => [el])

        expect(el.namespaces).to eq({})
      end
    end
  end

  describe '#default_namespace?' do
    it 'returns true when an element has no explicit namespace' do
      expect(described_class.new(:name => 'a').default_namespace?).to eq(true)
    end

    it 'returns true when an element has an explicit default namespace' do
      element   = described_class.new(:name => 'a')
      namespace = Oga::XML::DEFAULT_NAMESPACE

      element.register_namespace(namespace.name, namespace.uri)

      expect(element.default_namespace?).to eq(true)
    end

    it 'returns false when an element resides in a custom namespace' do
      element = described_class.new(:name => 'a')

      element.register_namespace('xmlns', 'foo')

      expect(element.default_namespace?).to eq(false)
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
      expect(@n2.text).to eq('FooBar')
    end

    it 'returns the text of the child node' do
      expect(@n1.text).to eq('Foo')
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
      expect(@n2.inner_text).to eq('Bar')
    end

    it 'returns the inner text of the child node' do
      expect(@n1.inner_text).to eq('Foo')
    end
  end

  describe '#inner_text=' do
    before do
      @element = described_class.new
    end

    it 'sets the inner text of an element' do
      @element.inner_text = 'foo'
      expect(@element.inner_text).to eq('foo')
    end

    it 'removes all existing nodes before inserting a new text node' do
      @element.children << Oga::XML::Text.new(:text => 'foo')
      @element.children << Oga::XML::Element.new(:name => 'x')

      @element.inner_text = 'bar'

      expect(@element.children.length).to eq(1)
    end

    it 'sets the parent node of the newly inserted text node' do
      @element.inner_text = 'foo'

      expect(@element.children[0].parent).to eq(@element)
    end
  end

  describe '#text_nodes' do
    before do
      @t1 = Oga::XML::Text.new(:text => 'Foo')
      @t2 = Oga::XML::Text.new(:text => 'Bar')

      @element = described_class.new(:children => [@t1, @t2])
    end

    it 'returns a node set containing the text nodes' do
      expect(@element.text_nodes).to eq(node_set(@t1, @t2))
    end
  end

  describe '#to_xml' do
    it 'generates the corresponding XML' do
      expect(described_class.new(:name => 'p').to_xml).to eq('<p />')
    end

    it 'includes the namespace if present' do
      instance = described_class.new(
        :name           => 'p',
        :namespace_name => 'foo',
        :namespaces     => {'foo' => Oga::XML::Namespace.new(:name => 'foo')},
        :children       => [Oga::XML::Text.new(:text => 'Foo')]
      )

      expect(instance.to_xml).to eq('<foo:p>Foo</foo:p>')
    end

    it 'includes a single attribute if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => [
          Oga::XML::Attribute.new(:name => 'key', :value => 'value')
        ]
      )

      expect(instance.to_xml).to eq('<p key="value" />')
    end

    it 'includes multiple attributes if present' do
      instance = described_class.new(
        :name       => 'p',
        :attributes => [
          Oga::XML::Attribute.new(:name => 'key1', :value => 'value1'),
          Oga::XML::Attribute.new(:name => 'key2', :value => 'value2'),
        ]
      )

      expect(instance.to_xml).to eq('<p key1="value1" key2="value2" />')
    end

    it 'includes the child nodes if present' do
      instance = described_class.new(
        :name     => 'p',
        :children => [Oga::XML::Comment.new(:text => 'foo')]
      )

      expect(instance.to_xml).to eq('<p><!--foo--></p>')
    end

    it 'generates the corresponding XML when using a default namespace' do
      namespace = Oga::XML::Namespace.new(:name => 'xmlns', :uri => 'foo')
      instance  = described_class.new(
        :name       => 'foo',
        :namespaces => {'xmlns' => namespace}
      )

      expect(instance.to_xml).to eq('<foo />')
    end

    it 'generates the XML for the HTML <script> element' do
      element  = described_class.new(:name => 'script')
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      expect(element.to_xml).to eq('<script></script>')
    end

    it 'generates the XML for the HTML <link> element' do
      element  = described_class.new(:name => 'link')
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      expect(element.to_xml).to eq('<link>')
    end

    it 'generates the XML for an empty explicitly closed HTML element' do
      element = described_class.new(:name => 'html')
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      expect(element.to_xml).to eq('<html></html>')
    end
  end

  describe '#inspect' do
    it 'inspects a node with a name' do
      node = described_class.new(:name => 'a')

      expect(node.inspect).to eq('Element(name: "a")')
    end

    it 'inspects a node with attributes and children' do
      node = described_class.new(
        :name       => 'p',
        :children   => [Oga::XML::Comment.new(:text => 'foo')],
        :attributes => [Oga::XML::Attribute.new(:name => 'x', :value => 'y')]
      )

      expect(node.inspect).to eq('Element(name: "p" attributes: ' \
        '[Attribute(name: "x" value: "y")] children: NodeSet(Comment("foo")))')
    end

    it 'inspects a node with a namespace' do
      node = described_class.new(
        :name           => 'p',
        :namespace_name => 'x',
        :namespaces     => {'x' => Oga::XML::Namespace.new(:name => 'x')}
      )

      expect(node.inspect).to eq('Element(name: "p" ' \
        'namespace: Namespace(name: "x" uri: nil))')
    end
  end

  describe '#register_namespace' do
    before do
      @element = described_class.new

      @element.register_namespace('foo', 'http://example.com')
    end

    it 'returns a Namespace instance' do
      expect(@element.namespaces['foo'].is_a?(Oga::XML::Namespace)).to eq(true)
    end

    it 'sets the name of the namespace' do
      expect(@element.namespaces['foo'].name).to eq('foo')
    end

    it 'sets the URI of the namespace' do
      expect(@element.namespaces['foo'].uri).to eq('http://example.com')
    end

    it 'raises ArgumentError if the namespace already exists' do
      block = lambda { @element.register_namespace('foo', 'bar') }

      expect(block).to raise_error(ArgumentError)
    end

    it 'flushes the cache when registering a namespace' do
      expect(@element.available_namespaces).to eq({
        'foo' => @element.namespaces['foo']
      })

      @element.register_namespace('bar', 'http://exmaple.com')

      expect(@element.available_namespaces).to eq({
        'foo' => @element.namespaces['foo'],
        'bar' => @element.namespaces['bar']
      })
    end

    it 'does not flush the cache when "flush" is set to false' do
      expect(@element).not_to receive(:flush_namespaces_cache)

      @element.register_namespace('bar', 'http://example.com', false)
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
      expect(@child_ns['foo'].uri).to eq('bar')
    end

    it 'overwrites the "baz" namespace in the child' do
      expect(@child_ns['baz'].uri).to eq('xxx')
    end

    it 'returns the "foo" namespace for the parent' do
      expect(@parent_ns['foo'].uri).to eq('bar')
    end

    it 'returns the "baz" namespace for the parent' do
      expect(@parent_ns['baz'].uri).to eq('yyy')
    end

    it 'does not modify the list of direct namespaces' do
      expect(@child.namespaces.key?('foo')).to eq(false)
    end

    describe 'in an HTML document' do
      it 'returns an empty Hash' do
        ns  = Oga::XML::Namespace.new(:name => 'xmlns')
        el  = described_class.new(:namespaces => {'xmlns' => ns})
        doc = Oga::XML::Document.new(:type => :html, :children => [el])

        expect(el.available_namespaces).to eq({})
      end
    end
  end

  describe '#self_closing?' do
    it 'returns true for an empty XML element' do
      expect(described_class.new(:name => 'foo')).to be_self_closing
    end

    it 'returns false for a non empty XML element' do
      text = Oga::XML::Text.new(:text => 'bar')
      node = described_class.new(:name => 'foo', :children => [text])

      expect(node).not_to be_self_closing
    end

    it 'returns true for an HTML void element' do
      element  = described_class.new(:name => 'link')
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      expect(element).to be_self_closing
    end

    it 'returns false for a non empty HTML element' do
      text     = Oga::XML::Text.new(:text => 'alert()')
      element  = described_class.new(:name => 'script', :children => [text])
      document = Oga::XML::Document.new(:type => :html, :children => [element])

      expect(element).not_to be_self_closing
    end
  end

  describe '#flush_namespaces_cache' do
    it 'flushes the namespaces cache of the current element' do
      element = described_class.new(:name => 'a')

      expect(element.available_namespaces).to eq({})

      element.register_namespace('foo', 'bar', false)

      element.flush_namespaces_cache

      expect(element.available_namespaces).to eq({
        'foo' => element.namespaces['foo']
      })
    end

    it 'flushes the namespace cache of all child elements' do
      child  = described_class.new(:name => 'b')
      parent = described_class.new(:name => 'a', :children => [child])

      expect(child).to receive(:flush_namespaces_cache)

      parent.flush_namespaces_cache
    end
  end

  describe '#expanded_name' do
    describe 'with a namespace' do
      it 'returns a String' do
        element = described_class.new(:namespace_name => 'foo', :name => 'bar')

        expect(element.expanded_name).to eq('foo:bar')
      end
    end

    describe 'without a namespace' do
      it 'returns a String' do
        element = described_class.new(:name => 'bar')

        expect(element.expanded_name).to eq('bar')
      end
    end
  end

  describe '#literal_html_name?' do
    it 'returns true for an element name matching one of the literal HTML elements' do
      expect(described_class.new(:name => 'script').literal_html_name?).to eq(true)
    end

    it 'returns false for an element name not matching one of the literal HTML elements' do
      expect(described_class.new(:name => 'foo').literal_html_name?).to eq(false)
    end
  end
end
