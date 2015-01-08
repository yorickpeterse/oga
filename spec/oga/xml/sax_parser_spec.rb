require 'spec_helper'

describe Oga::XML::SaxParser do
  before do
    @handler = Class.new do
      attr_reader :name, :after_namespace, :after_name

      def on_element(namespace, name, attrs = {})
        @name = name
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
end
