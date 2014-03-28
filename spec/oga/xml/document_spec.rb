require 'spec_helper'

describe Oga::XML::Document do
  context 'setting attributes' do
    example 'set the child nodes via the constructor' do
      children = [Oga::XML::Comment.new(:text => 'foo')]
      document = described_class.new(:children => children)

      document.children.should == children
    end

    example 'set the child nodes via a setter' do
      children = [Oga::XML::Comment.new(:text => 'foo')]
      document = described_class.new

      document.children = children

      document.children.should == children
    end
  end

  context '#to_xml' do
    before do
      child = Oga::XML::Comment.new(:text => 'foo')
      @document = described_class.new(:children => [child])
    end

    example 'generate the corresponding XML' do
      @document.to_xml.should == '<!--foo-->'
    end
  end
end
