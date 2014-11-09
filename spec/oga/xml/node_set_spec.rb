require 'spec_helper'

describe Oga::XML::NodeSet do
  context '#initialize' do
    example 'create an empty node set' do
      described_class.new.length.should == 0
    end

    example 'create a node set with a single node' do
      node = Oga::XML::Element.new(:name => 'p')

      described_class.new([node]).length.should == 1
    end

    example 'set the owner of a set' do
      node = Oga::XML::Element.new
      set  = described_class.new([], node)

      set.owner.should == node
    end

    example 'take ownership of the nodes when the set has an owner' do
      node = Oga::XML::Element.new
      set  = described_class.new([node], node)

      node.node_set.should == set
    end

    example 'only store unique nodes' do
      n1  = Oga::XML::Element.new(:name => 'a')
      set = described_class.new([n1, n1])

      set.length.should == 1
    end
  end

  context '#each' do
    example 'yield the block for every node' do
      n1 = Oga::XML::Element.new(:name => 'a')
      n2 = Oga::XML::Element.new(:name => 'b')

      set     = described_class.new([n1, n2])
      yielded = []

      set.each { |node| yielded << node }

      yielded.should == [n1, n2]
    end
  end

  context 'Enumerable behaviour' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @n2  = Oga::XML::Element.new(:name => 'b')
      @set = described_class.new([@n1, @n2])
    end

    example 'return the first node' do
      @set.first.should == @n1
    end

    example 'return the last node' do
      @set.last.should == @n2
    end

    example 'return the amount of nodes' do
      @set.count.should  == 2
      @set.length.should == 2
      @set.size.should   == 2
    end

    example 'return a boolean that indicates if a set is empty or not' do
      @set.empty?.should == false
    end
  end

  context '#index' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @n2  = Oga::XML::Element.new(:name => 'b')
      @set = described_class.new([@n1, @n2])
    end

    example 'return the index of the first node' do
      @set.index(@n1).should == 0
    end

    example 'return the index of the last node' do
      @set.index(@n2).should == 1
    end
  end

  context '#push' do
    before do
      @set = described_class.new
    end

    example 'push a node into the set' do
      @set.push(Oga::XML::Element.new(:name => 'a'))

      @set.length.should == 1
    end

    example 'do not push a node that is already part of the set' do
      element = Oga::XML::Element.new(:name => 'a')

      @set.push(element)
      @set.push(element)

      @set.length.should == 1
    end

    example 'take ownership of a node if the set has an owner' do
      child      = Oga::XML::Element.new
      @set.owner = Oga::XML::Element.new

      @set.push(child)

      child.node_set.should == @set
    end
  end

  context '#unshift' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    example 'push a node at the beginning of the set' do
      n2  = Oga::XML::Element.new(:name => 'b')

      @set.unshift(n2)

      @set.first.should == n2
    end

    example 'do not push a node if it is already part of the set' do
      @set.unshift(@n1)

      @set.length.should == 1
    end

    example 'take ownership of a node if the set has an owner' do
      child      = Oga::XML::Element.new
      @set.owner = Oga::XML::Element.new

      @set.unshift(child)

      child.node_set.should == @set
    end
  end

  context '#shift' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @set  = described_class.new([@n1], owner)
    end

    example 'remove the node from the set' do
      @set.shift
      @set.empty?.should == true
    end

    example 'return the node when shifting it' do
      @set.shift.should == @n1
    end

    example 'remove ownership if the node belongs to a node set' do
      @set.shift

      @n1.node_set.nil?.should == true
    end
  end

  context '#pop' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @set  = described_class.new([@n1], owner)
    end

    example 'remove the node from the set' do
      @set.pop
      @set.empty?.should == true
    end

    example 'return the node when popping it' do
      @set.pop.should == @n1
    end

    example 'remove ownership if the node belongs to a node set' do
      @set.pop

      @n1.node_set.nil?.should == true
    end
  end

  context '#insert' do
    before do
      @set       = described_class.new
      @owned_set = described_class.new([], Oga::XML::Node.new)
    end

    example 'insert a node into an empty node set' do
      node = Oga::XML::Node.new

      @set.insert(0, node)

      @set[0].should == node
    end

    example 'do not insert a node that is already in the set' do
      node = Oga::XML::Node.new

      @set.insert(0, node)
      @set.insert(0, node)

      @set.length.should == 1
    end

    example 'insert a node before another node' do
      node1 = Oga::XML::Node.new
      node2 = Oga::XML::Node.new

      @set.insert(0, node1)
      @set.insert(0, node2)

      @set[0].should == node2
      @set[1].should == node1
    end

    example 'take ownership of a node when inserting into an owned set' do
      node = Oga::XML::Node.new

      @owned_set.insert(0, node)

      node.node_set.should == @owned_set
    end
  end

  context '#[]' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    example 'return a node from a given index' do
      @set[0].should == @n1
    end
  end

  context '#to_a' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    example 'convert a set to an Array' do
      @set.to_a.should == [@n1]
    end
  end

  context '#+' do
    before do
      @n1   = Oga::XML::Element.new(:name => 'a')
      @n2   = Oga::XML::Element.new(:name => 'b')
      @set1 = described_class.new([@n1])
      @set2 = described_class.new([@n2])
    end

    example 'merge two sets together' do
      (@set1 + @set2).to_a.should == [@n1, @n2]
    end

    example 'ignore duplicate nodes' do
      (@set1 + described_class.new([@n1])).length.should == 1
    end
  end

  context '#==' do
    before do
      node  = Oga::XML::Node.new
      @set1 = described_class.new([node])
      @set2 = described_class.new([node])
      @set3 = described_class.new
    end

    example 'return true if two node sets are equal' do
      @set1.should == @set2
    end

    example 'return false if two node sets are not equal' do
      @set1.should_not == @set3
    end
  end

  context '#concat' do
    before do
      n1 = Oga::XML::Element.new(:name => 'a')
      n2 = Oga::XML::Element.new(:name => 'b')

      @set1 = described_class.new([n1])
      @set2 = described_class.new([n2])
    end

    example 'concatenate two node sets' do
      @set1.concat(@set2)

      @set1.length.should == 2
    end
  end

  context '#remove' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @n2   = Oga::XML::Element.new

      @doc_set   = described_class.new([@n1, @n2], owner)
      @query_set = described_class.new([@n1, @n2])
    end

    example 'do not remove the nodes from the current set' do
      @query_set.remove

      @query_set.empty?.should == false
    end

    example 'remove the nodes from the owning set' do
      @query_set.remove

      @doc_set.empty?.should == true
    end

    example 'unlink the nodes from the sets they belong to' do
      @query_set.remove

      @n1.node_set.nil?.should == true
      @n2.node_set.nil?.should == true
    end

    example 'remove all nodes from the owned set' do
      @doc_set.remove

      @doc_set.empty?.should == true
    end
  end

  context '#delete' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @set  = described_class.new([@n1], owner)
    end

    example 'return the node when deleting it' do
      @set.delete(@n1).should == @n1
    end

    example 'remove the node from the set' do
      @set.delete(@n1)

      @set.empty?.should == true
    end

    example 'remove ownership of the removed node' do
      @set.delete(@n1)

      @n1.node_set.nil?.should == true
    end
  end

  context '#attribute' do
    before do
      @attr = Oga::XML::Attribute.new(:name => 'a', :value => '1')
      @el   = Oga::XML::Element.new(:name => 'a', :attributes => [@attr])
      @txt  = Oga::XML::Text.new(:text => 'foo')
      @set  = described_class.new([@el, @txt])
    end

    example 'return the values of an attribute' do
      @set.attribute('a').should == [@attr]
    end
  end

  context '#text' do
    before do
      child   = Oga::XML::Text.new(:text => 'foo')
      comment = Oga::XML::Comment.new(:text => 'bar')
      cdata   = Oga::XML::Cdata.new(:text => 'baz')
      text    = Oga::XML::Text.new(:text => "\nbar")

      @el = Oga::XML::Element.new(
        :name     => 'a',
        :children => described_class.new([child, comment, cdata])
      )

      @set = described_class.new([@el, text])
    end

    example 'return the text of all nodes' do
      @set.text.should == "foobaz\nbar"
    end
  end
end
