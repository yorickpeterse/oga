require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':nth-last-of-type pseudo class' do
    before do
      @document = parse(<<-EOF.strip)
<root>
  <a id="1" />
  <a id="2" />
  <a id="3" />
  <b>
    <a id="4" />
  </b>
</root>
      EOF

      @root = @document.children[0]
      @a1   = @root.at_xpath('a[1]')
      @a2   = @root.at_xpath('a[2]')
      @a3   = @root.at_xpath('a[3]')
      @a4   = @root.at_xpath('b/a')
    end

    it 'returns a node set containing the first child node' do
      expect(evaluate_css(@document, 'root a:nth-last-of-type(1)'))
        .to eq(node_set(@a3, @a4))
    end

    it 'returns a node set containing even nodes' do
      expect(evaluate_css(@document, 'root a:nth-last-of-type(even)'))
        .to eq(node_set(@a2))
    end

    it 'returns a node set containing odd nodes' do
      expect(evaluate_css(@document, 'root a:nth-last-of-type(odd)'))
        .to eq(node_set(@a1, @a3, @a4))
    end

    it 'returns a node set containing every 2 nodes starting at node 2' do
      expect(evaluate_css(@document, 'root a:nth-last-of-type(2n+2)'))
        .to eq(node_set(@a2))
    end

    it 'returns a node set containing all nodes' do
      expect(evaluate_css(@document, 'root a:nth-last-of-type(n)'))
        .to eq(node_set(@a1, @a2, @a3, @a4))
    end

    it 'returns a node set containing the first two nodes' do
      expect(evaluate_css(@document, 'root a:nth-last-of-type(-n+2)'))
        .to eq(node_set(@a2, @a3, @a4))
    end

    it 'returns a node set containing all nodes starting at node 2' do
      expect(evaluate_css(@document, 'root a:nth-last-of-type(n+2)'))
        .to eq(node_set(@a1, @a2))
    end
  end
end
