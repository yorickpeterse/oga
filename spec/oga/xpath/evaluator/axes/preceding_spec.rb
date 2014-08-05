require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'preceding axis' do
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

      @first_foo  = @document.children[0].children[0]
      @first_bar  = @first_foo.children[0]
      @first_baz  = @first_foo.children[1]
      @second_baz = @first_baz.children[0]
      @evaluator  = described_class.new(@document)
    end

    context 'matching nodes in the current context' do
      before do
        @set = @evaluator.evaluate('root/foo/baz/preceding::bar')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <bar> node' do
        @set[0].should == @first_bar
      end
    end

    context 'matching nodes in other contexts' do
      before do
        @set = @evaluator.evaluate('root/baz/preceding::baz')
      end

      it_behaves_like :node_set, :length => 2

      example 'return the first <baz> node' do
        @set[0].should == @first_baz
      end

      example 'return the second <baz> node' do
        @set[1].should == @second_baz
      end
    end
  end
end
