require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'using a regular processing instruction' do
    before do
      @document = parse('<a><?a foo ?><b><?b bar ?></b></a>')

      @proc_ins1 = @document.children[0].children[0]
      @proc_ins2 = @document.children[0].children[1].children[0]
    end

    describe 'relative to a document' do
      describe 'a/processing-instruction()' do
        it 'returns a NodeSet' do
          expect(evaluate_xpath(@document)).to eq(node_set(@proc_ins1))
        end
      end

      describe 'a/b/processing-instruction()' do
        it 'returns a NodeSet' do
          expect(evaluate_xpath(@document)).to eq(node_set(@proc_ins2))
        end
      end
    end
  end

  describe 'using an XML declaration' do
    it 'returns a NodeSet containing the XmlDeclaration' do
      document = parse('<root><?xml version="1.0" ?></root>')
      xml_decl = document.children[0].children[0]

      expect(evaluate_xpath(document, 'root/processing-instruction()'))
        .to eq(node_set(xml_decl))
    end
  end
end
