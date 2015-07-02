require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @compiler = described_class.new
  end

  describe '#compile' do
    it 'returns a Proc as a lambda' do
      ast   = parse_xpath('foo')
      block = @compiler.compile(ast)

      block.should be_an_instance_of(Proc)
      block.lambda?.should == true
    end

    it 'returns a Proc with a single required argument' do
      ast = parse_xpath('foo')

      # Only the input document is required.
      @compiler.compile(ast).arity.should == 1
    end

    xit 'caches a compiled Proc for a given XPath AST' do
      # TODO
    end

    describe 'calling the compiled Proc' do
      it 'returns a NodeSet' do
        doc   = parse('<foo></foo>')
        ast   = parse_xpath('foo')
        block = @compiler.compile(ast)

        block.call(doc).should be_an_instance_of(NodeSet)
      end
    end
  end
end
