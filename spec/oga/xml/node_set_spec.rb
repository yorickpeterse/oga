require 'spec_helper'

describe Oga::XML::NodeSet do
  describe '#initialize' do
    it 'creates an empty node set' do
      described_class.new.length.should == 0
    end

    it 'creates a node set with a single node' do
      node = Oga::XML::Element.new(:name => 'p')

      described_class.new([node]).length.should == 1
    end

    it 'sets the owner of a set' do
      node = Oga::XML::Element.new
      set  = described_class.new([], node)

      set.owner.should == node
    end

    it 'takes ownership of the nodes when the set has an owner' do
      node = Oga::XML::Element.new
      set  = described_class.new([node], node)

      node.node_set.should == set
    end

    it 'sets the previous and next nodes for all nodes owned by the set' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new
      set   = described_class.new([node1, node2], node1)

      node1.next.should     == node2
      node1.previous.should == nil

      node2.next.should     == nil
      node2.previous.should == node1
    end

    it 'does not set the previous and next nodes for nodes that are not owned' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new
      set   = described_class.new([node1, node2])

      node1.previous.should == nil
      node1.next.should     == nil

      node2.previous.should == nil
      node2.next.should     == nil
    end
  end

  describe '#each' do
    it 'yields the block for every node' do
      n1 = Oga::XML::Element.new(:name => 'a')
      n2 = Oga::XML::Element.new(:name => 'b')

      set     = described_class.new([n1, n2])
      yielded = []

      set.each { |node| yielded << node }

      yielded.should == [n1, n2]
    end
  end

  describe 'Enumerable behaviour' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @n2  = Oga::XML::Element.new(:name => 'b')
      @set = described_class.new([@n1, @n2])
    end

    it 'returns the first node' do
      @set.first.should == @n1
    end

    it 'returns the last node' do
      @set.last.should == @n2
    end

    it 'returns the amount of nodes' do
      @set.count.should  == 2
      @set.length.should == 2
      @set.size.should   == 2
    end

    it 'returns a boolean that indicates if a set is empty or not' do
      @set.empty?.should == false
    end
  end

  describe '#index' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @n2  = Oga::XML::Element.new(:name => 'b')
      @set = described_class.new([@n1, @n2])
    end

    it 'returns the index of the first node' do
      @set.index(@n1).should == 0
    end

    it 'returns the index of the last node' do
      @set.index(@n2).should == 1
    end
  end

  describe '#push' do
    before do
      @set = described_class.new
    end

    it 'pushes a node into the set' do
      @set.push(Oga::XML::Element.new(:name => 'a'))

      @set.length.should == 1
    end

    it 'does not push a node that is already part of the set' do
      element = Oga::XML::Element.new(:name => 'a')

      @set.push(element)
      @set.push(element)

      @set.length.should == 1
    end

    it 'takes ownership of a node if the set has an owner' do
      child      = Oga::XML::Element.new
      @set.owner = Oga::XML::Element.new

      @set.push(child)

      child.node_set.should == @set
    end

    it 'updates the previous and next nodes of any owned nodes' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new

      @set.owner = node1

      @set.push(node1)
      @set.push(node2)

      node1.next.should     == node2
      node1.previous.should == nil

      node2.next.should     == nil
      node2.previous.should == node1
    end
  end

  describe '#unshift' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    it 'pushes a node at the beginning of the set' do
      n2  = Oga::XML::Element.new(:name => 'b')

      @set.unshift(n2)

      @set.first.should == n2
    end

    it 'does not push a node if it is already part of the set' do
      @set.unshift(@n1)

      @set.length.should == 1
    end

    it 'takes ownership of a node if the set has an owner' do
      child      = Oga::XML::Element.new
      @set.owner = Oga::XML::Element.new

      @set.unshift(child)

      child.node_set.should == @set
    end

    it 'updates the next node of the added node' do
      node = Oga::XML::Element.new
      @set.owner = node

      @set.unshift(node)

      node.next.should == @n1
    end

    it 'updates the previous node of the existing node' do
      node = Oga::XML::Element.new
      @set.owner = node

      @set.unshift(node)

      @n1.previous.should == node
    end
  end

  describe '#shift' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @set  = described_class.new([@n1], owner)
    end

    it 'removes the node from the set' do
      @set.shift
      @set.empty?.should == true
    end

    it 'returns the node when shifting it' do
      @set.shift.should == @n1
    end

    it 'removes ownership if the node belongs to a node set' do
      @set.shift

      @n1.node_set.nil?.should == true
    end

    it 'updates the previous and next nodes of the removed node' do
      @set.shift

      @n1.previous.should == nil
      @n1.next.should     == nil
    end

    it 'updates the previous node of the remaining node' do
      node = Oga::XML::Element.new

      @set.push(node)
      @set.shift

      node.previous.should == nil
    end
  end

  describe '#pop' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @set  = described_class.new([@n1], owner)
    end

    it 'removes the node from the set' do
      @set.pop
      @set.empty?.should == true
    end

    it 'returns the node when popping it' do
      @set.pop.should == @n1
    end

    it 'removes ownership if the node belongs to a node set' do
      @set.pop

      @n1.node_set.nil?.should == true
    end

    it 'updates the previous node of the removed node' do
      @set.pop

      @n1.previous.should == nil
    end

    it 'updates the next node of the last remaining node' do
      node = Oga::XML::Element.new

      @set.push(node)
      @set.pop

      @n1.next.should == nil
    end
  end

  describe '#insert' do
    before do
      @set       = described_class.new
      @owned_set = described_class.new([], Oga::XML::Node.new)
    end

    it 'inserts a node into an empty node set' do
      node = Oga::XML::Node.new

      @set.insert(0, node)

      @set[0].should == node
    end

    it 'does not insert a node that is already in the set' do
      node = Oga::XML::Node.new

      @set.insert(0, node)
      @set.insert(0, node)

      @set.length.should == 1
    end

    it 'inserts a node before another node' do
      node1 = Oga::XML::Node.new
      node2 = Oga::XML::Node.new

      @set.insert(0, node1)
      @set.insert(0, node2)

      @set[0].should == node2
      @set[1].should == node1
    end

    it 'takes ownership of a node when inserting into an owned set' do
      node = Oga::XML::Node.new

      @owned_set.insert(0, node)

      node.node_set.should == @owned_set
    end

    it 'updates the previous and next nodes of the inserted node' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new
      node3 = Oga::XML::Element.new

      @owned_set.push(node1)
      @owned_set.push(node2)

      @owned_set.insert(1, node3)

      node3.previous.should == node1
      node3.next.should     == node2
    end

    it 'updates the next node of the node preceding the inserted node' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new

      @owned_set.push(node1)
      @owned_set.insert(1, node2)

      node1.next.should == node2
    end

    it 'updates the previous node of the node following the inserted node' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new

      @owned_set.push(node1)
      @owned_set.insert(0, node2)

      node1.previous.should == node2
    end
  end

  describe '#[]' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    it 'returns a node from a given index' do
      @set[0].should == @n1
    end
  end

  describe '#to_a' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    it 'converts a set to an Array' do
      @set.to_a.should == [@n1]
    end
  end

  describe '#+' do
    before do
      @n1   = Oga::XML::Element.new(:name => 'a')
      @n2   = Oga::XML::Element.new(:name => 'b')
      @set1 = described_class.new([@n1])
      @set2 = described_class.new([@n2])
    end

    it 'merges two sets together' do
      (@set1 + @set2).to_a.should == [@n1, @n2]
    end

    it 'ignores duplicate nodes' do
      (@set1 + described_class.new([@n1])).length.should == 1
    end
  end

  describe '#==' do
    before do
      node  = Oga::XML::Node.new
      @set1 = described_class.new([node])
      @set2 = described_class.new([node])
      @set3 = described_class.new
    end

    it 'returns true if two node sets are equal' do
      @set1.should == @set2
    end

    it 'returns false if two node sets are not equal' do
      @set1.should_not == @set3
    end
  end

  describe '#concat' do
    before do
      n1 = Oga::XML::Element.new(:name => 'a')
      n2 = Oga::XML::Element.new(:name => 'b')

      @set1 = described_class.new([n1])
      @set2 = described_class.new([n2])
    end

    it 'concatenates two node sets' do
      @set1.concat(@set2)

      @set1.length.should == 2
    end
  end

  describe '#remove' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @n2   = Oga::XML::Element.new

      @doc_set   = described_class.new([@n1, @n2], owner)
      @query_set = described_class.new([@n1, @n2])
    end

    it 'does not remove the nodes from the current set' do
      @query_set.remove

      @query_set.empty?.should == false
    end

    it 'removes the nodes from the owning set' do
      @query_set.remove

      @doc_set.empty?.should == true
    end

    it 'unlinks the nodes from the sets they belong to' do
      @query_set.remove

      @n1.node_set.nil?.should == true
      @n2.node_set.nil?.should == true
    end

    it 'removes all nodes from the owned set' do
      @doc_set.remove

      @doc_set.empty?.should == true
    end

    it 'updates the previous and next nodes for all removed nodes' do
      @doc_set.remove

      @n1.previous.should == nil
      @n1.next.should     == nil

      @n2.previous.should == nil
      @n2.next.should     == nil
    end
  end

  describe '#delete' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @set  = described_class.new([@n1], owner)
    end

    it 'returns the node when deleting it' do
      @set.delete(@n1).should == @n1
    end

    it 'removes the node from the set' do
      @set.delete(@n1)

      @set.empty?.should == true
    end

    it 'removes ownership of the removed node' do
      @set.delete(@n1)

      @n1.node_set.nil?.should == true
    end

    it 'updates the previous and next nodes of the removed node' do
      node = Oga::XML::Element.new

      @set.push(node)
      @set.delete(@n1)

      @n1.previous.should == nil
      @n1.next.should     == nil
    end
  end

  describe '#attribute' do
    before do
      @attr = Oga::XML::Attribute.new(:name => 'a', :value => '1')
      @el   = Oga::XML::Element.new(:name => 'a', :attributes => [@attr])
      @txt  = Oga::XML::Text.new(:text => 'foo')
      @set  = described_class.new([@el, @txt])
    end

    it 'returns the values of an attribute' do
      @set.attribute('a').should == [@attr]
    end
  end

  describe '#text' do
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

    it 'returns the text of all nodes' do
      @set.text.should == "foobaz\nbar"
    end
  end
end
