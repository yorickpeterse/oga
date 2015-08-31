require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'using variable bindings' do
    before do
      @document = parse('<a></a>')
      @compiler = described_class.new
    end

    describe 'when a variable is defined' do
      it 'returns the value of a variable' do
        ast   = parse_xpath('$number')
        block = @compiler.compile(ast)

        block.call(@document, 'number' => 10.0).should == 10.0
      end
    end

    describe 'when a variable is undefined' do
      it 'raises RuntimeError' do
        ast   = parse_xpath('$number')
        block = @compiler.compile(ast)

        proc { block.call(@document) }.should
          raise_error 'Undefined XPath variable: number'
      end
    end
  end
end
