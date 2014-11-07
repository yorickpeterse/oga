require 'spec_helper'

describe 'CSS selector evaluation' do
  before do
    @document = parse('<a xmlns:ns1="x"><b></b><b></b><ns1:c></ns1:c></a>')
  end

  context 'regular paths' do
    before do
      @set = evaluate_css(@document, 'a')
    end

    it_behaves_like :node_set, :length => 1

    example 'include the <a> node' do
      @set[0].should == @document.children[0]
    end
  end

  context 'nested paths' do
    before do
      @set = evaluate_css(@document, 'a b')
    end

    it_behaves_like :node_set, :length => 2

    example 'include the first <b> node' do
      @set[0].should == @document.children[0].children[0]
    end

    example 'include the second <b> node' do
      @set[1].should == @document.children[0].children[1]
    end
  end

  context 'paths with namespaces' do
    before do
      @set = evaluate_css(@document, 'a ns1|c')
    end

    it_behaves_like :node_set, :length => 1

    example 'include the <n1:c> node' do
      @set[0].should == @document.children[0].children[2]
    end
  end

  context 'paths with name wildcards' do
    before do
      @set = evaluate_css(@document, 'a *')
    end

    it_behaves_like :node_set, :length => 3

    example 'include the first <b> node' do
      @set[0].should == @document.children[0].children[0]
    end

    example 'include the second <b> node' do
      @set[1].should == @document.children[0].children[1]
    end

    example 'include the second <ns1:c> node' do
      @set[2].should == @document.children[0].children[2]
    end
  end

  context 'paths with namespace wildcards' do
    before do
      @set = evaluate_css(@document, 'a *|c')
    end

    it_behaves_like :node_set, :length => 1

    example 'include the <ns1:c> node' do
      @set[0].should == @document.children[0].children[2]
    end
  end

  context 'paths with namespaces and name wildcards' do
    before do
      @set = evaluate_css(@document, 'a ns1|*')
    end

    it_behaves_like :node_set, :length => 1

    example 'include the <ns1:c> node' do
      @set[0].should == @document.children[0].children[2]
    end
  end

  context 'paths with full wildcards' do
    before do
      @set = evaluate_css(@document, 'a *|*')
    end

    it_behaves_like :node_set, :length => 3

    example 'include the first <b> node' do
      @set[0].should == @document.children[0].children[0]
    end

    example 'include the second <b> node' do
      @set[1].should == @document.children[0].children[1]
    end

    example 'include the second <ns1:c> node' do
      @set[2].should == @document.children[0].children[2]
    end
  end
end
