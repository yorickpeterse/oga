require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document  = parse('<a>Hello</a>')
    @evaluator = described_class.new(@document)
  end

  context '#function_node' do
    before do
      @context_set = Oga::XML::NodeSet.new([@document])
    end

    example 'return the first node in the expression' do
      exp  = s(:axis, 'child', s(:test, nil, 'a'))
      node = @evaluator.function_node(@context_set, exp)

      node.should == @document.children[0]
    end

    example 'raise a TypeError if the expression did not return a node set' do
      exp   = s(:call, 'false')
      block = lambda { @evaluator.function_node(@context_set, exp) }

      block.should raise_error(TypeError)
    end

    example 'use the current context node if the expression is empty' do
      a_node = @document.children[0]

      @evaluator.stub(:current_node).and_return(a_node)

      @evaluator.function_node(@context_set).should == a_node
    end
  end

  context '#first_node_text' do
    example 'return the text of the first node' do
      @evaluator.first_node_text(@document.children).should == 'Hello'
    end

    example 'return an empty string if the node set is empty' do
      set = Oga::XML::NodeSet.new

      @evaluator.first_node_text(set).should == ''
    end
  end

  context '#child_nodes' do
    before do
      @children = Oga::XML::NodeSet.new([
        Oga::XML::Element.new(:name => 'b'),
        Oga::XML::Element.new(:name => 'b')
      ])

      @parent = Oga::XML::Element.new(:name => 'a', :children => @children)
    end

    example "return a node's child nodes" do
      nodes = @evaluator.child_nodes([@parent])

      nodes[0].should == @children[0]
      nodes[1].should == @children[1]
    end
  end

  context '#node_matches?' do
    before do
      @name_node    = Oga::XML::Element.new(:name => 'a')
      @name_ns_node = Oga::XML::Element.new(:name => 'b', :namespace_name => 'x')

      @name_ns_node.register_namespace('x', 'y')
    end

    example 'return true if a node is matched by its name' do
      @evaluator.node_matches?(@name_node, s(:test, nil, 'a')).should == true
    end

    example 'return true if a node is matched by a wildcard name' do
      @evaluator.node_matches?(@name_node, s(:test, nil, '*')).should == true
    end

    example 'return false if a node is not matched by its name' do
      @evaluator.node_matches?(@name_node, s(:test, nil, 'foo')).should == false
    end

    example 'return true if a node is matched by its name and namespace' do
      @evaluator.node_matches?(@name_ns_node, s(:test, 'x', 'b')).should == true
    end

    example 'return false if a node is not matched by its namespace' do
      @evaluator.node_matches?(@name_ns_node, s(:test, 'y', 'b')).should == false
    end

    example 'return true if a node is matched by a wildcard namespace' do
      @evaluator.node_matches?(@name_ns_node, s(:test, '*', 'b')).should == true
    end

    example 'return true if a node is matched by a full wildcard search' do
      @evaluator.node_matches?(@name_ns_node, s(:test, '*', '*')).should == true
    end

    example 'return true if a node is matched without having a namespace' do
      @evaluator.node_matches?(@name_node, s(:test, '*', 'a')).should == true
    end

    example 'return false when trying to match an XML::Text instance' do
      text = Oga::XML::Text.new(:text => 'Foobar')

      @evaluator.node_matches?(text, s(:test, nil, 'a')).should == false
    end

    example 'return false when the node has a namespace that is not given' do
      @evaluator.node_matches?(@name_ns_node, s(:test, nil, 'b')).should == false
    end

    example 'return true if a node with a namespace is matched using a wildcard' do
      @evaluator.node_matches?(@name_ns_node, s(:test, nil, '*')).should == true
    end

    example 'return true if the node type matches' do
      @evaluator.node_matches?(@name_node, s(:type_test, 'node')).should == true
    end
  end

  context '#type_matches?' do
    before do
      @element = Oga::XML::Element.new(:name => 'a')
      @ns      = Oga::XML::Namespace.new(:name => 'a')
    end

    example 'return true if the type matches' do
      @evaluator.type_matches?(@element, s(:type_test, 'node')).should == true
    end

    example 'return false if the type does not match' do
      @evaluator.type_matches?(@ns, s(:type_test, 'node')).should == false
    end
  end

  context '#has_parent?' do
    before do
      @parent = Oga::XML::Element.new
      @child  = Oga::XML::Element.new

      set = Oga::XML::NodeSet.new([@child], @parent)
    end

    example 'return true if a node has a parent node' do
      @evaluator.has_parent?(@child).should == true
    end

    example 'return false if a node has no parent node' do
      @evaluator.has_parent?(@parent).should == false
    end
  end
end
