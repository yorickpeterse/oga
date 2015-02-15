require 'spec_helper'

describe Oga::XML::SaxParser do
  describe '#parse' do
    before do
      @handler = Class.new do
        attr_reader :name, :attrs, :after_namespace, :after_name

        def on_element(namespace, name, attrs = {})
          @name  = name
          @attrs = attrs
        end

        def after_element(namespace, name)
          @after_namespace = namespace
          @after_name      = name
        end
      end
    end

    it 'ignores return values of callback methods' do
      parser = described_class.new(@handler.new, 'foo')

      parser.parse.should be_nil
    end

    it 'uses custom callback methods if defined' do
      handler = @handler.new
      parser  = described_class.new(handler, '<foo />')

      parser.parse

      handler.name.should == 'foo'
    end

    it 'always passes element names to after_element' do
      handler = @handler.new
      parser  = described_class.new(handler, '<namespace:foo />')

      parser.parse

      handler.after_name.should      == 'foo'
      handler.after_namespace.should == 'namespace'
    end

    it 'ignores callbacks that are not defined in the handler' do
      parser = described_class.new(@handler.new, '<!--foo-->')

      # This would raise if undefined callbacks were _not_ ignored.
      lambda { parser.parse }.should_not raise_error
    end

    it 'passes the attributes to the on_element callback' do
      handler = @handler.new
      parser  = described_class.new(handler, '<a b="10" x:c="20" />')

      parser.parse

      handler.attrs.should == {'b' => '10', 'x:c' => '20'}
    end
  end

  describe '#on_attribute' do
    before do
      @handler_without = Class.new.new

      @handler_with = Class.new do
        def on_attribute(name, ns = nil, value = nil)
          return {name.upcase => value}
        end
      end.new
    end

    it 'returns a default Hash if no custom callback exists' do
      parser = described_class.new(@handler_without, '<a x:foo="bar" />')
      hash   = parser.on_attribute('foo', 'x', 'bar')

      hash.should == {'x:foo' => 'bar'}
    end

    it 'returns the return value of a custom callback' do
      parser = described_class.new(@handler_with, nil)
      hash   = parser.on_attribute('foo', 'x', 'bar')

      hash.should == {'FOO' => 'bar'}
    end
  end

  describe '#on_attributes' do
    before do
      @handler_without = Class.new.new

      @handler_with = Class.new do
        def on_attributes(attrs)
          return %w{Alice Bob} # these two again
        end
      end.new
    end

    it 'merges all attributes into a Hash if no callback is defined' do
      parser = described_class.new(@handler_without, nil)
      hash   = parser.on_attributes([{'a' => 'b'}, {'c' => 'd'}])

      hash.should == {'a' => 'b', 'c' => 'd'}
    end

    it 'returns the return value of a custom callback' do
      parser = described_class.new(@handler_with, nil)
      retval = parser.on_attributes([{'a' => 'b'}, {'c' => 'd'}])

      retval.should == %w{Alice Bob}
    end
  end
end
