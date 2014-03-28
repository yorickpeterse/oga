require 'spec_helper'

describe Oga::XML::Node do
  context '#initialize' do
    example 'set the parent node' do
      parent = described_class.new
      child  = described_class.new(:parent => parent)

      child.parent.should == parent
    end

    example 'set the default child nodes' do
      described_class.new.children.should == []
    end
  end
end
