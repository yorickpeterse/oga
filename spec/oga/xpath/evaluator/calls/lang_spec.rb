require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'lang() function' do
    before do
      @document  = parse('<root xml:lang="en"><a></a><a xml:lang="nl"></a></root>')
      @evaluator = described_class.new(@document)
    end

    context 'selecting nodes with lang="en"' do
      before do
        @set = @evaluator.evaluate('root[lang("en")]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the <root> node' do
        @set[0].should == @document.children[0]
      end
    end

    context 'selecting nodes with lang="nl"' do
      before do
        @set = @evaluator.evaluate('root/a[lang("nl")]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the second <a> node' do
        @set[0].should == @document.children[0].children[1]
      end
    end

    context 'inheriting the language from ancestor nodes' do
      before do
        @set = @evaluator.evaluate('root/a[lang("en")]')
      end

      it_behaves_like :node_set, :length => 1

      example 'return the first <a> node' do
        @set[0].should == @document.children[0].children[0]
      end
    end
  end
end
