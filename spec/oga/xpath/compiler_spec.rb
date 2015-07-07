require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @compiler = described_class.new
  end

  describe 'compile_with_cache' do
    before do
      described_class::CACHE.clear
    end

    it 'returns a Proc as a lambda' do
      ast   = parse_xpath('foo')
      block = described_class.compile_with_cache(ast)

      block.should be_an_instance_of(Proc)
      block.lambda?.should == true
    end

    it 'caches a compiled Proc' do
      ast = parse_xpath('foo')

      described_class.any_instance
        .should_receive(:compile)
        .once
        .and_call_original

      described_class.compile_with_cache(ast).should be_an_instance_of(Proc)
      described_class.compile_with_cache(ast).should be_an_instance_of(Proc)
    end
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

    describe 'calling the compiled Proc' do
      it 'returns a NodeSet' do
        doc   = parse('<foo></foo>')
        ast   = parse_xpath('foo')
        block = @compiler.compile(ast)

        block.call(doc).should be_an_instance_of(Oga::XML::NodeSet)
      end
    end
  end
end
