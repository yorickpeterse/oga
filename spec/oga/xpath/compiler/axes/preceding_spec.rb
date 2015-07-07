require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'preceding axis' do
    before do
      @document = parse(<<-EOF.strip.gsub(/\s+/m, ''))
<root>
  <foo>
    <bar></bar>
    <baz>
      <baz></baz>
    </baz>
  </foo>
  <baz></baz>
</root>
      EOF

      @foo1 = @document.children[0].children[0]
      @bar1 = @foo1.children[0]
      @baz1 = @foo1.children[1]
      @baz2 = @baz1.children[0]
      @baz3 = @document.children[0].children[1]
    end

    it 'returns a node set containing preceding nodes of root/foo/baz' do
      evaluate_xpath(@document, 'root/foo/baz/preceding::bar')
        .should == node_set(@bar1)
    end

    it 'returns a node set containing preceding nodes for root/baz' do
      evaluate_xpath(@document, 'root/baz/preceding::baz')
        .should == node_set(@baz1, @baz2)
    end

    it 'returns a node set containing preceding nodes relative to root/baz' do
      evaluate_xpath(@baz3, 'preceding::baz').should == node_set(@baz1, @baz2)
    end
  end
end
