require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'using variable bindings' do
    before do
      @document = parse('<a></a>')
      @compiler = described_class.new
    end

    it 'returns the value of a variable' do
      ast   = parse_xpath('$number')
      block = @compiler.compile(ast)

      block.call(@document, 'number' => 10.0).should == 10.0
    end

    it 'raises RuntimeError when evaluating an unbound variable' do
      ast   = parse_xpath('$number')
      block = @compiler.compile(ast)

      proc { block.call(@document) }.should
        raise_error 'Undefined XPath variable: number'
    end
  end
end
