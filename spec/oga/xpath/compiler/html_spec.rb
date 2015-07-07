require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'querying HTML documents' do
    before do
      @document = parse_html('<html xmlns="foo"><body></body></html>')
      @body     = @document.children[0].children[0]
    end

    it 'returns a NodeSet when a custom default namespace is declared' do
      evaluate_xpath(@document, 'html/body').should == node_set(@body)
    end
  end
end
