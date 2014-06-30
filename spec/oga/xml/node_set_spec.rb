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

    example 'take ownership of a node if the set has an owner' do
      child      = Oga::XML::Element.new
      @set.owner = Oga::XML::Element.new

      @set.push(child)

      child.node_set.should == @set
    end
  end

  context '#unshift' do
    before do
      n1   = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([n1])
    end

    example 'push a node at the beginning of the set' do
      n2  = Oga::XML::Element.new(:name => 'b')

      @set.unshift(n2)

      @set.first.should == n2
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

  context '#[]' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    example 'return a node from a given index' do
      @set[0].should == @n1
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
  end

  context '#delete' do
    before do
      @n1  = Oga::XML::Element.new(:name => 'a')
      @set = described_class.new([@n1])
    end

    example 'return the node when deleting it' do
      @set.delete(@n1).should == @n1
    end

    example 'remove the node from the set' do
      @set.delete(@n1)

      @set.empty?.should == true
    end
  end

  context '#attribute' do
    before do
      @el  = Oga::XML::Element.new(:name => 'a', :attributes => {:a => '1'})
      @txt = Oga::XML::Text.new(:text => 'foo')
      @set = described_class.new([@el, @txt])
    end

    example 'return the values of an attribute' do
      @set.attribute('a').should == ['1']
    end
  end

  context '#text' do
    before do
      child = Oga::XML::Text.new(:text => 'foo')

      @el = Oga::XML::Element.new(
        :name     => 'a',
        :children => described_class.new([child])
      )

      @txt = Oga::XML::Text.new(:text => "\nbar")
      @set = described_class.new([@el, @txt])
    end

    example 'return the text of all nodes' do
      @set.text.should == "foo\nbar"
    end
  end
end
