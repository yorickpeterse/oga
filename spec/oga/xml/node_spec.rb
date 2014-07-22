require 'spec_helper'

describe Oga::XML::Node do
  context '#initialize' do
    example 'set the node set' do
      set  = Oga::XML::NodeSet.new
      node = described_class.new(:node_set => set)

      node.node_set.should == set
    end
  end

  context '#type' do
    example 'return the type of the node' do
      described_class.new.node_type.should == :node
    end
  end

  context '#children' do
    example 'return an empty set by default' do
      described_class.new.children.empty?.should == true
    end

    example 'return a set that was created manually' do
      set  = Oga::XML::NodeSet.new([described_class.new])
      node = described_class.new(:children => set)

      node.children.should == set
    end
  end

  context '#children=' do
    example 'set the child nodes using an Array' do
      child = described_class.new
      node  = described_class.new

      node.children = [child]

      node.children[0].should == child
    end

    example 'set the child nodes using a NodeSet' do
      child = described_class.new
      node  = described_class.new

      node.children = Oga::XML::NodeSet.new([child])

      node.children[0].should == child
    end
  end

  context '#parent' do
    example 'return the parent of the node' do
      owner = described_class.new
      set   = Oga::XML::NodeSet.new([], owner)
      node  = described_class.new(:node_set => set)

      node.parent.should == owner
    end

    example 'return nil if there is no parent node' do
      described_class.new.parent.nil?.should == true
    end
  end

  context '#previous' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @n2   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2], owner)
    end

    example 'return the previous node' do
      @n2.previous.should == @n1
    end

    example 'return nil if there is no previous node' do
      @n1.previous.nil?.should == true
    end
  end

  context '#next' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @n2   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2], owner)
    end

    example 'return the next node' do
      @n1.next.should == @n2
    end

    example 'return nil if there is no previous node' do
      @n2.next.nil?.should == true
    end
  end

  context '#previous_element' do
    before do
      owner = described_class.new
      @n1   = Oga::XML::Element.new
      @n2   = Oga::XML::Text.new
      @n3   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2, @n3], owner)
    end

    example 'return the previous element of a generic node' do
      @n3.previous_element.should == @n1
    end

    example 'return the previous element of a text node' do
      @n2.previous_element.should == @n1
    end

    example 'return nil if there is no previous element' do
      @n1.previous_element.nil?.should == true
    end
  end

  context '#next_element' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @n2   = Oga::XML::Text.new
      @n3   = Oga::XML::Element.new
      @set  = Oga::XML::NodeSet.new([@n1, @n2, @n3], owner)
    end

    example 'return the next element of a generic node' do
      @n1.next_element.should == @n3
    end

    example 'return the next element of a text node' do
      @n2.next_element.should == @n3
    end

    example 'return nil if there is no next element' do
      @n3.next_element.nil?.should == true
    end
  end

  context '#root_node' do
    before do
      @n4  = described_class.new
      @n3  = described_class.new(:children => [@n4])
      @n2  = described_class.new
      @n1  = described_class.new(:children => [@n2])
      @doc = Oga::XML::Document.new(:children => [@n1])
    end

    example 'return the root document of an element' do
      @n2.root_node.should == @doc
    end

    example 'return the root element of another element' do
      @n4.root_node.should == @n3
    end
  end

  context '#remove' do
    before do
      owner = described_class.new
      @n1   = described_class.new
      @set  = Oga::XML::NodeSet.new([@n1], owner)
    end

    example 'return a node from the node set' do
      @n1.remove

      @set.empty?.should == true
    end

    example 'remove the reference to the set' do
      @n1.remove

      @n1.node_set.nil?.should == true
    end
  end
end
