require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document  = parse('<a>Hello</a>')
    @evaluator = described_class.new(@document)
  end

  describe '#function_node' do
    before do
      @document    = parse('<root><a>Hello</a></root>')
      @context_set = @document.children
    end

    it 'returns the first node in the expression' do
      exp  = s(:axis, 'child', s(:test, nil, 'a'))
      node = @evaluator.function_node(@context_set, exp)

      node.should == @context_set[0].children[0]
    end

    it 'raises a TypeError if the expression did not return a node set' do
      exp   = s(:call, 'false')
      block = lambda { @evaluator.function_node(@context_set, exp) }

      block.should raise_error(TypeError)
    end

    it 'uses the current context node if the expression is empty' do
      @evaluator.function_node(@context_set).should == @context_set[0]
    end
  end

  describe '#first_node_text' do
    it 'returns the text of the first node' do
      @evaluator.first_node_text(@document.children).should == 'Hello'
    end

    it 'returns an empty string if the node set is empty' do
      set = Oga::XML::NodeSet.new

      @evaluator.first_node_text(set).should == ''
    end
  end

  describe '#child_nodes' do
    before do
      @children = Oga::XML::NodeSet.new([
        Oga::XML::Element.new(:name => 'b'),
        Oga::XML::Element.new(:name => 'b')
      ])

      @parent = Oga::XML::Element.new(:name => 'a', :children => @children)
    end

    it "returns a node's child nodes" do
      nodes = @evaluator.child_nodes([@parent])

      nodes[0].should == @children[0]
      nodes[1].should == @children[1]
    end
  end

  describe '#node_matches?' do
    describe 'without a namespace' do
      before do
        @node = Oga::XML::Element.new(:name => 'a')
      end

      it 'returns true if a node is matched by its name' do
        @evaluator.node_matches?(@node, s(:test, nil, 'a')).should == true
      end

      it 'returns true if a node is matched by a wildcard name' do
        @evaluator.node_matches?(@node, s(:test, nil, '*')).should == true
      end

      it 'returns false if a node is not matched by its name' do
        @evaluator.node_matches?(@node, s(:test, nil, 'foo')).should == false
      end

      it 'returns true if a node is matched without having a namespace' do
        @evaluator.node_matches?(@node, s(:test, '*', 'a')).should == true
      end

      it 'returns true if the node type matches' do
        @evaluator.node_matches?(@node, s(:type_test, 'node')).should == true
      end

      it 'returns false when trying to match an XML::Text instance' do
        text = Oga::XML::Text.new(:text => 'Foobar')

        @evaluator.node_matches?(text, s(:test, nil, 'a')).should == false
      end
    end

    describe 'with a custom namespace' do
      before do
        @node = Oga::XML::Element.new(:name => 'b', :namespace_name => 'x')

        @node.register_namespace('x', 'y')
      end

      it 'returns true if a node is matched by its name and namespace' do
        @evaluator.node_matches?(@node, s(:test, 'x', 'b')).should == true
      end

      it 'returns false if a node is not matched by its namespace' do
        @evaluator.node_matches?(@node, s(:test, 'y', 'b')).should == false
      end

      it 'returns true if a node is matched by a wildcard namespace' do
        @evaluator.node_matches?(@node, s(:test, '*', 'b')).should == true
      end

      it 'returns true if a node is matched by a full wildcard search' do
        @evaluator.node_matches?(@node, s(:test, '*', '*')).should == true
      end

      it 'returns false when the node has a namespace that is not given' do
        @evaluator.node_matches?(@node, s(:test, nil, 'b')).should == false
      end

      it 'returns true if a node with a namespace is matched using a wildcard' do
        @evaluator.node_matches?(@node, s(:test, nil, '*')).should == true
      end
    end

    describe 'using the default XML namespace' do
      before do
        @node = Oga::XML::Element.new(:name => 'a')
        ns    = Oga::XML::DEFAULT_NAMESPACE

        @node.register_namespace(ns.name, ns.uri)
      end

      it 'returns true when the node name matches' do
        @evaluator.node_matches?(@node, s(:test, nil, 'a')).should == true
      end

      it 'returns true when the namespace prefix and node name match' do
        @evaluator.node_matches?(@node, s(:test, 'xmlns', 'a')).should == true
      end

      it 'returns false when the node name does not match' do
        @evaluator.node_matches?(@node, s(:test, nil, 'b')).should == false
      end
    end
  end

  describe '#type_matches?' do
    before do
      @element = Oga::XML::Element.new(:name => 'a')
      @ns      = Oga::XML::Namespace.new(:name => 'a')
    end

    it 'returns true if the type matches' do
      @evaluator.type_matches?(@element, s(:type_test, 'node')).should == true
    end

    it 'returns false if the type does not match' do
      @evaluator.type_matches?(@ns, s(:type_test, 'node')).should == false
    end
  end

  describe '#has_parent?' do
    before do
      @parent = Oga::XML::Element.new
      @child  = Oga::XML::Element.new

      set = Oga::XML::NodeSet.new([@child], @parent)
    end

    it 'returns true if a node has a parent node' do
      @evaluator.has_parent?(@child).should == true
    end

    it 'returns false if a node has no parent node' do
      @evaluator.has_parent?(@parent).should == false
    end
  end

  describe '#to_string' do
    it 'converts a float to a string' do
      @evaluator.to_string(10.5).should == '10.5'
    end

    it 'converts a float without decimals to a string' do
      @evaluator.to_string(10.0).should == '10'
    end
  end

  describe '#to_float' do
    it 'converts a string to a float' do
      @evaluator.to_float('10').should == 10.0
    end

    it "returns NaN for values that can't be converted to floats" do
      @evaluator.to_float('a').should be_nan
    end
  end
end
