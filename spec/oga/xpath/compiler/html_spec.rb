require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse_html('<html xmlns="foo"><body></body></html>')
    @body     = @document.children[0].children[0]
  end

  describe 'relative to an HTML document' do
    describe 'html/body' do
      it 'returns a NodeSet' do
        expect(evaluate_xpath(@document)).to eq(node_set(@body))
      end
    end
  end
end
