require 'spec_helper'

describe Oga::XML::Traversal do
  describe '#each_node' do
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

    it 'yields the nodes in document order' do
      names = []

      @document.each_node do |node|
        names << (node.is_a?(Oga::XML::Element) ? node.name : node.text)
      end

      expect(names).to eq(%w{books book1 title1 Foo book2 title2 Bar})
    end

    it 'skips child nodes when skip_children is thrown' do
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

      expect(names).to eq(%w{books book2 title2})
    end

    describe 'without a block' do
      it 'returns an enumerator' do
        enum = @document.each_node
        expect(enum).to be_a(Enumerator)

        names = enum.to_a.map do |node| 
          node.is_a?(Oga::XML::Element) ? node.name : node.text
        end
        expect(names).to eq(%w{books book1 title1 Foo book2 title2 Bar})
      end
    end
  end
end
