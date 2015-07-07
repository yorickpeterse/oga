require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'processing-instruction() tests' do
    before do
      @document = parse('<a><?a foo ?><b><?b bar ?></b></a>')

      @proc_ins1 = @document.children[0].children[0]
      @proc_ins2 = @document.children[0].children[1].children[0]
    end

    it 'returns a node set containing processing instructions' do
      evaluate_xpath(@document, 'a/processing-instruction()')
        .should == node_set(@proc_ins1)
    end

    it 'returns a node set containing nested processing instructions' do
      evaluate_xpath(@document, 'a/b/processing-instruction()')
        .should == node_set(@proc_ins2)
    end
  end
end
