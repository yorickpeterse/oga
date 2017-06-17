require 'spec_helper'

describe Oga::XML::Attribute do
  describe '#initialize' do
    it 'sets the name' do
      expect(described_class.new(:name => 'a').name).to eq('a')
    end

    it 'sets the value' do
      expect(described_class.new(:value => 'a').value).to eq('a')
    end
  end

  describe '#parent' do
    it 'returns the parent Element' do
      element = Oga::XML::Element.new(:name => 'foo')
      attr    = described_class.new(:element => element)

      expect(attr.parent).to eq(element)
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
      expect(@attribute.namespace).to eq(@namespace)
    end

    it 'returns the default XML namespace when the "xml" prefix is used' do
      expect(@default.namespace).to eq(Oga::XML::Attribute::DEFAULT_NAMESPACE)
    end
  end

  describe '#value=' do
    it 'sets the value of an attribute' do
      attr = described_class.new

      attr.value = 'foo'

      expect(attr.value).to eq('foo')
    end

    it 'flushes the decoded cache when setting a new value' do
      attr = described_class.new(:value => '&lt;')

      expect(attr.value).to eq(Oga::XML::Entities::DECODE_MAPPING['&lt;'])

      attr.value = '&gt;'

      expect(attr.value).to eq(Oga::XML::Entities::DECODE_MAPPING['&gt;'])
    end
  end

  describe '#value' do
    it 'returns the value of an attribute' do
      expect(described_class.new(:value => 'foo').value).to eq('foo')
    end

    describe 'using an XML document' do
      before do
        @el  = Oga::XML::Element.new(:name => 'a')
        @doc = Oga::XML::Document.new(:children => [@el], :type => :xml)
      end

      it 'returns a String with decoded XML entities' do
        attr = described_class.new(
          :name    => 'class',
          :value   => '&lt;',
          :element => @el
        )

        expect(attr.value).to eq('<')
      end
    end

    describe 'using HTML documents' do
      before do
        @el  = Oga::XML::Element.new(:name => 'a')
        @doc = Oga::XML::Document.new(:children => [@el], :type => :html)
      end

      it 'returns a String with decoded HTML entities' do
        attr = described_class.new(
          :name    => 'class',
          :value   => '&copy;',
          :element => @el
        )

        expect(attr.value).to eq(Oga::HTML::Entities::DECODE_MAPPING['&copy;'])
      end
    end
  end

  describe '#text' do
    it 'returns an empty String when there is no value' do
      expect(described_class.new.text).to eq('')
    end

    it 'returns the value if it is present' do
      expect(described_class.new(:value => 'a').text).to eq('a')
    end
  end

  describe '#to_xml' do
    it 'converts an attribute to XML' do
      attr = described_class.new(:name => 'foo', :value => 'bar')

      expect(attr.to_xml).to eq('foo="bar"')
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

      expect(attr.to_xml).to eq('foo:class="10"')
    end

    it 'includes the "xmlns" namespace when present but not registered' do
      attr = described_class.new(
        :name           => 'class',
        :namespace_name => 'xmlns',
        :element        => Oga::XML::Element.new
      )

      expect(attr.to_xml).to eq('xmlns:class=""')
    end

    it 'decodes XML entities' do
      attr = described_class.new(:name => 'href', :value => %q{&<>'"})

      expect(attr.to_xml).to eq('href="&amp;&lt;&gt;&apos;&quot;"')
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

      expect(obj.inspect).to eq <<-EOF.strip
Attribute(name: "a" namespace: Namespace(name: "b" uri: nil) value: "c")
EOF
    end
  end

  describe '#expanded_name' do
    describe 'with a namespace' do
      it 'returns a String' do
        attr = described_class.new(:namespace_name => 'foo', :name => 'bar')

        expect(attr.expanded_name).to eq('foo:bar')
      end
    end

    describe 'without a namespace' do
      it 'returns a String' do
        attr = described_class.new(:name => 'bar')

        expect(attr.expanded_name).to eq('bar')
      end
    end
  end

  describe '#each_ancestor' do
    describe 'without an element' do
      it 'simply returns' do
        attr = described_class.new(:name => 'class')

        expect { |b| attr.each_ancestor(&b) }.to_not yield_control
      end
    end

    describe 'with an element' do
      it 'yields the supplied block for every ancestor' do
        child  = Oga::XML::Element.new(:name => 'b')
        parent = Oga::XML::Element.new(:name => 'a', :children => [child])
        attr   = described_class.new(:name => 'class', :element => child)

        expect { |b| attr.each_ancestor(&b) }
          .to yield_successive_args(child, parent)
      end
    end
  end
end
