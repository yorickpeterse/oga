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

      @second_foo = @document.children[0].children[1].children[0]
      @evaluator  = described_class.new(@document)
    end

    context 'matching nodes in the current context' do
      before do
        @set = @evaluator.evaluate('root/bar/baz/preceding-sibling::foo')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the second <foo> node' do
        @set[0].should == @second_foo
      end
    end
  end
end
