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

  describe '#parent' do
    it 'returns the parent Element' do
      element = Oga::XML::Element.new(:name => 'foo')
      attr    = described_class.new(:element => element)

      attr.parent.should == element
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
      @default.namespace.should == Oga::XML::Attribute::DEFAULT_NAMESPACE
    end
  end

  describe '#value=' do
    it 'sets the value of an attribute' do
      attr = described_class.new

      attr.value = 'foo'

      attr.value.should == 'foo'
    end

    it 'flushes the decoded cache when setting a new value' do
      attr = described_class.new(:value => '&lt;')

      attr.value.should == Oga::XML::Entities::DECODE_MAPPING['&lt;']

      attr.value = '&gt;'

      attr.value.should == Oga::XML::Entities::DECODE_MAPPING['&gt;']
    end
  end

  describe '#value' do
    it 'returns the value of an attribute' do
      described_class.new(:value => 'foo').value.should == 'foo'
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

        attr.value.should == '<'
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

        attr.value.should == Oga::HTML::Entities::DECODE_MAPPING['&copy;']
      end
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

    it 'decodes XML entities' do
      attr = described_class.new(:name => 'href', :value => %q{&<>'"})

      attr.to_xml.should == 'href="&amp;&lt;&gt;&apos;&quot;"'
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

  describe '#expanded_name' do
    describe 'with a namespace' do
      it 'returns a String' do
        attr = described_class.new(:namespace_name => 'foo', :name => 'bar')

        attr.expanded_name.should == 'foo:bar'
      end
    end

    describe 'without a namespace' do
      it 'returns a String' do
        attr = described_class.new(:name => 'bar')

        attr.expanded_name.should == 'bar'
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
