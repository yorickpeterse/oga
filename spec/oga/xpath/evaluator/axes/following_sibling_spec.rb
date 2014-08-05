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

      @first_baz  = @document.children[0].children[0].children[1]
      @second_baz = @first_baz.children[0]
      @third_baz  = @document.children[0].children[1]
      @evaluator  = described_class.new(@document)
    end

    # This should return an empty set since the document doesn't have any
    # following nodes.
    context 'using a document as the root' do
      before do
        @set = @evaluator.evaluate('following-sibling::foo')
      end

      it_behaves_like :empty_node_set
    end

    context 'matching nodes in the current context' do
      before do
        @set = @evaluator.evaluate('root/foo/following-sibling::baz')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the third <baz> node' do
        @set[0].should == @third_baz
      end
    end

    context 'matching nodes in a deeper context' do
      before do
        @set = @evaluator.evaluate('root/foo/bar/following-sibling::baz')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <baz> node' do
        @set[0].should == @first_baz
      end
    end
  end
end
