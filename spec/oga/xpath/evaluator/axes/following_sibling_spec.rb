require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'following-sibling axis' do
    before do
      # Strip whitespace so it's easier to retrieve/compare elements.
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

      @bar1 = @document.children[0].children[0].children[0]
      @baz1 = @document.children[0].children[0].children[1]
      @baz2 = @baz1.children[0]
      @baz3 = @document.children[0].children[1]
    end

    # This should return an empty set since the document doesn't have any
    # following nodes.
    example 'return an empty node set for the sibling of a document' do
      evaluate_xpath(@document, 'following-sibling::foo').should == node_set
    end

    example 'return a node set containing the siblings of root/foo' do
      evaluate_xpath(@document, 'root/foo/following-sibling::baz')
        .should == node_set(@baz3)
    end

    example 'return a node set containing the siblings of root/foo/bar' do
      evaluate_xpath(@document, 'root/foo/bar/following-sibling::baz')
        .should == node_set(@baz1)
    end

    example 'return a node set containing the siblings relative to root/foo/bar' do
      evaluate_xpath(@bar1, 'following-sibling::baz').should == node_set(@baz1)
    end
  end
end
