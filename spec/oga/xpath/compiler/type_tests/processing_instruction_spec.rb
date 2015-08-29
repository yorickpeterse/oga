require 'spec_helper'

describe Oga::XPath::Compiler do
  before do
    @document = parse('<a><?a foo ?><b><?b bar ?></b></a>')

    @proc_ins1 = @document.children[0].children[0]
    @proc_ins2 = @document.children[0].children[1].children[0]
  end

  describe 'relative to a document' do
    describe 'a/processing-instruction()' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@proc_ins1)
      end
    end

    describe 'a/b/processing-instruction()' do
      it 'returns a NodeSet' do
        evaluate_xpath(@document).should == node_set(@proc_ins2)
      end
    end
  end
end
