require 'spec_helper'

describe Oga::XML::Traversal do
  context '#each_node' do
    before do
      @document = parse(<<-EOF.strip.gsub(/\s+/m, ''))
<books>
  <book1>
    <title1>Foo</title1>
  </book1>
  <book2>
    <title2>Bar</title2>
  </book2>
</books>
      EOF
    end

    example 'yield the nodes in document order' do
      names = []

      @document.each_node do |node|
        names << (node.is_a?(Oga::XML::Element) ? node.name : node.text)
      end

      names.should == %w{books book1 title1 Foo book2 title2 Bar}
    end

    example 'skip child nodes when skip_children is thrown' do
      names = []

      @document.each_node do |node|
        if node.is_a?(Oga::XML::Element)
          if node.name == 'book1'
            throw :skip_children
          else
            names << node.name
          end
        end
      end

      names.should == %w{books book2 title2}
    end
  end
end
