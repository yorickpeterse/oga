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

    describe 'calling the compiled Proc' do
      it 'returns a NodeSet' do
        doc   = parse('<foo></foo>')
        ast   = parse_xpath('foo')
        block = @compiler.compile(ast)

        block.call(doc).should be_an_instance_of(Oga::XML::NodeSet)
      end
    end

    # This test relies on Binding#receiver (Binding#self on Rubinius), which
    # sadly isn't available on all tested Ruby versions.
    #
    # Procs should have their own Binding as otherwise concurrent usage could
    # lead to race conditions due to variable scopes and such being re-used.
    [:receiver, :self].each do |binding_method|
      if Binding.method_defined?(binding_method)
        describe 'the returned Proc' do
          it 'uses an isolated Binding' do
            ast   = parse_xpath('foo')
            block = @compiler.compile(ast)

            binding_context = block.binding.send(binding_method)

            binding_context.should be_an_instance_of(Oga::XPath::Context)
          end
        end

        break
      end
    end
  end
end
