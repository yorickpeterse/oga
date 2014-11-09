require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'preceding-sibling axis' do
    before do
      @document = parse(<<-EOF.strip.gsub(/\s+/m, ''))
<root>
  <foo>
  </foo>
  <bar>
    <foo></foo>
    <baz></baz>
  </bar>
</root>
      EOF

      @foo1 = @document.children[0].children[0]
      @foo2 = @document.children[0].children[1].children[0]
    end

    example 'return a node set containing preceding siblings of root/bar' do
      evaluate_xpath(@document, 'root/bar/preceding-sibling::foo')
        .should == node_set(@foo1)
    end

    example 'return a node set containing preceding siblings of root/bar/baz' do
      evaluate_xpath(@document, 'root/bar/baz/preceding-sibling::foo')
        .should == node_set(@foo2)
    end
  end
end
