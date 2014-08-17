require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'pipe operator' do
    before do
      @document  = parse('<root><a></a><b></b></root>')
      @evaluator = described_class.new(@document)
    end

    context 'merge two sets' do
      before do
        @set = @evaluator.evaluate('/root/a | /root/b')
      end

      it_behaves_like :node_set, :length => 2

      example 'include the <a> node' do
        @set[0].name.should == 'a'
      end

      example 'include the <b> node' do
        @set[1].name.should == 'b'
      end
    end

    context 'merge two sets when the left hand side is empty' do
      before do
        @set = @evaluator.evaluate('foo | /root/b')
      end

      it_behaves_like :node_set, :length => 1

      example 'include the <b> node' do
        @set[0].name.should == 'b'
      end
    end

    context 'merge two sets when the right hand side is empty' do
      before do
        @set = @evaluator.evaluate('/root/a | foo')
      end

      it_behaves_like :node_set, :length => 1

      example 'include the <a> node' do
        @set[0].name.should == 'a'
      end
    end

    context 'merge two identical sets' do
      before do
        @set = @evaluator.evaluate('/root/a | /root/a')
      end

      it_behaves_like :node_set, :length => 1

      example 'include only a single <a> node' do
        @set[0].name.should == 'a'
      end
    end
  end
end
