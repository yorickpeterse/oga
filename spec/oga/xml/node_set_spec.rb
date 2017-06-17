require 'spec_helper'

describe Oga::XML::NodeSet do
  describe '#initialize' do
    it 'creates an empty node set' do
      expect(described_class.new.length).to eq(0)
    end

    it 'creates a node set with a single node' do
      node = Oga::XML::Element.new(:name => 'p')

      expect(described_class.new([node]).length).to eq(1)
    end

    it 'sets the owner of a set' do
      node = Oga::XML::Element.new
      set  = described_class.new([], node)

      expect(set.owner).to eq(node)
    end

    it 'takes ownership of the nodes when the set has an owner' do
      node = Oga::XML::Element.new
      set  = described_class.new([node], node)

      expect(node.node_set).to eq(set)
    end

    it 'sets the previous and next nodes for all nodes owned by the set' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new
      set   = described_class.new([node1, node2], node1)

      expect(node1.next).to     eq(node2)
      expect(node1.previous).to eq(nil)

      expect(node2.next).to     eq(nil)
      expect(node2.previous).to eq(node1)
    end

    it 'does not set the previous and next nodes for nodes that are not owned' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new
      set   = described_class.new([node1, node2])

      expect(node1.previous).to eq(nil)
      expect(node1.next).to     eq(nil)

      expect(node2.previous).to eq(nil)
      expect(node2.next).to     eq(nil)
    end
  end

  describe '#each' do
    it 'yields the block for every node' do
      n1 = Oga::XML::Element.new(:name => 'a')
      n2 = Oga::XML::Element.new(:name => 'b')

      set     = described_class.new([n1, n2])
      yielded = []

      set.each { |node| yielded << node }

      expect(yielded).to eq([n1, n2])
    end
  end

  describe 'Enumerable behaviour' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @n2  = Oga::XML::Element.new(:name => 'b')
      @set = described_class.new([@n1, @n2])
    end

    it 'returns the first node' do
      expect(@set.first).to eq(@n1)
    end

    it 'returns the last node' do
      expect(@set.last).to eq(@n2)
    end

    it 'returns the amount of nodes' do
      expect(@set.count).to  eq(2)
      expect(@set.length).to eq(2)
      expect(@set.size).to   eq(2)
    end

    it 'returns a boolean that indicates if a set is empty or not' do
      expect(@set.empty?).to eq(false)
    end
  end

  describe '#index' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @n2  = Oga::XML::Element.new(:name => 'b')
      @set = described_class.new([@n1, @n2])
    end

    it 'returns the index of the first node' do
      expect(@set.index(@n1)).to eq(0)
    end

    it 'returns the index of the last node' do
      expect(@set.index(@n2)).to eq(1)
    end
  end

  describe '#push' do
    before do
      @set = described_class.new
    end

    it 'pushes a node into the set' do
      @set.push(Oga::XML::Element.new(:name => 'a'))

      expect(@set.length).to eq(1)
    end

    it 'does not push a node that is already part of the set' do
      element = Oga::XML::Element.new(:name => 'a')

      @set.push(element)
      @set.push(element)

      expect(@set.length).to eq(1)
    end

    it 'takes ownership of a node if the set has an owner' do
      child      = Oga::XML::Element.new
      @set.owner = Oga::XML::Element.new

      @set.push(child)

      expect(child.node_set).to eq(@set)
    end

    it 'updates the previous and next nodes of any owned nodes' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new

      @set.owner = node1

      @set.push(node1)
      @set.push(node2)

      expect(node1.next).to     eq(node2)
      expect(node1.previous).to eq(nil)

      expect(node2.next).to     eq(nil)
      expect(node2.previous).to eq(node1)
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

      expect(@set.first).to eq(n2)
    end

    it 'does not push a node if it is already part of the set' do
      @set.unshift(@n1)

      expect(@set.length).to eq(1)
    end

    it 'takes ownership of a node if the set has an owner' do
      child      = Oga::XML::Element.new
      @set.owner = Oga::XML::Element.new

      @set.unshift(child)

      expect(child.node_set).to eq(@set)
    end

    it 'updates the next node of the added node' do
      node = Oga::XML::Element.new
      @set.owner = node

      @set.unshift(node)

      expect(node.next).to eq(@n1)
    end

    it 'updates the previous node of the existing node' do
      node = Oga::XML::Element.new
      @set.owner = node

      @set.unshift(node)

      expect(@n1.previous).to eq(node)
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
      expect(@set.empty?).to eq(true)
    end

    it 'returns the node when shifting it' do
      expect(@set.shift).to eq(@n1)
    end

    it 'removes ownership if the node belongs to a node set' do
      @set.shift

      expect(@n1.node_set.nil?).to eq(true)
    end

    it 'updates the previous and next nodes of the removed node' do
      @set.shift

      expect(@n1.previous).to eq(nil)
      expect(@n1.next).to     eq(nil)
    end

    it 'updates the previous node of the remaining node' do
      node = Oga::XML::Element.new

      @set.push(node)
      @set.shift

      expect(node.previous).to eq(nil)
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
      expect(@set.empty?).to eq(true)
    end

    it 'returns the node when popping it' do
      expect(@set.pop).to eq(@n1)
    end

    it 'removes ownership if the node belongs to a node set' do
      @set.pop

      expect(@n1.node_set.nil?).to eq(true)
    end

    it 'updates the previous node of the removed node' do
      @set.pop

      expect(@n1.previous).to eq(nil)
    end

    it 'updates the next node of the last remaining node' do
      node = Oga::XML::Element.new

      @set.push(node)
      @set.pop

      expect(@n1.next).to eq(nil)
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

      expect(@set[0]).to eq(node)
    end

    it 'does not insert a node that is already in the set' do
      node = Oga::XML::Node.new

      @set.insert(0, node)
      @set.insert(0, node)

      expect(@set.length).to eq(1)
    end

    it 'inserts a node before another node' do
      node1 = Oga::XML::Node.new
      node2 = Oga::XML::Node.new

      @set.insert(0, node1)
      @set.insert(0, node2)

      expect(@set[0]).to eq(node2)
      expect(@set[1]).to eq(node1)
    end

    it 'takes ownership of a node when inserting into an owned set' do
      node = Oga::XML::Node.new

      @owned_set.insert(0, node)

      expect(node.node_set).to eq(@owned_set)
    end

    it 'updates the previous and next nodes of the inserted node' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new
      node3 = Oga::XML::Element.new

      @owned_set.push(node1)
      @owned_set.push(node2)

      @owned_set.insert(1, node3)

      expect(node3.previous).to eq(node1)
      expect(node3.next).to     eq(node2)
    end

    it 'updates the next node of the node preceding the inserted node' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new

      @owned_set.push(node1)
      @owned_set.insert(1, node2)

      expect(node1.next).to eq(node2)
    end

    it 'updates the previous node of the node following the inserted node' do
      node1 = Oga::XML::Element.new
      node2 = Oga::XML::Element.new

      @owned_set.push(node1)
      @owned_set.insert(0, node2)

      expect(node1.previous).to eq(node2)
    end
  end

  describe '#[]' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    it 'returns a node from a given index' do
      expect(@set[0]).to eq(@n1)
    end
  end

  describe '#to_a' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    it 'converts a set to an Array' do
      expect(@set.to_a).to eq([@n1])
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
      expect((@set1 + @set2).to_a).to eq([@n1, @n2])
    end

    it 'ignores duplicate nodes' do
      expect((@set1 + described_class.new([@n1])).length).to eq(1)
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
      expect(@set1).to eq(@set2)
    end

    it 'returns false if two node sets are not equal' do
      expect(@set1).not_to eq(@set3)
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

      expect(@set1.length).to eq(2)
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

      expect(@query_set.empty?).to eq(false)
    end

    it 'removes the nodes from the owning set' do
      @query_set.remove

      expect(@doc_set.empty?).to eq(true)
    end

    it 'unlinks the nodes from the sets they belong to' do
      @query_set.remove

      expect(@n1.node_set.nil?).to eq(true)
      expect(@n2.node_set.nil?).to eq(true)
    end

    it 'removes all nodes from the owned set' do
      @doc_set.remove

      expect(@doc_set.empty?).to eq(true)
    end

    it 'updates the previous and next nodes for all removed nodes' do
      @doc_set.remove

      expect(@n1.previous).to eq(nil)
      expect(@n1.next).to     eq(nil)

      expect(@n2.previous).to eq(nil)
      expect(@n2.next).to     eq(nil)
    end
  end

  describe '#delete' do
    before do
      owner = Oga::XML::Element.new
      @n1   = Oga::XML::Element.new
      @set  = described_class.new([@n1], owner)
    end

    it 'returns the node when deleting it' do
      expect(@set.delete(@n1)).to eq(@n1)
    end

    it 'removes the node from the set' do
      @set.delete(@n1)

      expect(@set.empty?).to eq(true)
    end

    it 'removes ownership of the removed node' do
      @set.delete(@n1)

      expect(@n1.node_set.nil?).to eq(true)
    end

    it 'updates the previous and next nodes of the removed node' do
      node = Oga::XML::Element.new

      @set.push(node)
      @set.delete(@n1)

      expect(@n1.previous).to eq(nil)
      expect(@n1.next).to     eq(nil)
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
      expect(@set.attribute('a')).to eq([@attr])
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
      expect(@set.text).to eq("foobaz\nbar")
    end
  end
end
