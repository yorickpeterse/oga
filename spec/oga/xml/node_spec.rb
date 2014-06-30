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
end
