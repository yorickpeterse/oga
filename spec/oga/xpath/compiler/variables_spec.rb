require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'using variable bindings' do
    let(:document) { parse('<a></a>') }
    let(:compiler) { described_class.new }

    describe 'when a variable is defined' do
      it 'returns the value of a variable' do
        ast   = parse_xpath('$number')
        block = compiler.compile(ast)

        expect(block.call(document, 'number' => 10.0)).to eq(10.0)
      end
    end

    describe 'when a variable is undefined' do
      it 'raises RuntimeError' do
        ast   = parse_xpath('$number')
        block = compiler.compile(ast)

        expect { block.call(document) }
          .to raise_error('Undefined XPath variable: number')
      end
    end
  end
end
