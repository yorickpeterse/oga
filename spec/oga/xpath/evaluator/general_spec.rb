require 'spec_helper'

describe Oga::XPath::Evaluator do
  before do
    @document  = parse('<a>Hello</a>')
    @evaluator = described_class.new(@document)
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
      @name_ns_node = Oga::XML::Element.new(:name => 'b', :namespace => 'x')
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
  end

  context '#can_match_node?' do
    example 'return true for an XML::Element instance' do
      @evaluator.can_match_node?(Oga::XML::Element.new).should == true
    end

    example 'return true for an XML::Attribute instance' do
      @evaluator.can_match_node?(Oga::XML::Attribute.new).should == true
    end

    example 'return false for an XML::Text instance' do
      @evaluator.can_match_node?(Oga::XML::Text.new).should == false
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
