require 'spec_helper'

describe Oga::XPath::Compiler do
  describe 'descendant-or-self axis' do
    before do
      @document = parse('<a><b><b><c class="x"></c></b></b></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[0]
      @b2 = @b1.children[0]
      @c1 = @b2.children[0]
    end

    describe 'using the full syntax' do
      it 'returns a NodeSet containing a direct descendant' do
        evaluate_xpath(@document, 'descendant-or-self::b')
          .should == node_set(@b1, @b2)
      end

      it 'returns a NodeSet containing a nested descendant' do
        evaluate_xpath(@document, 'descendant-or-self::c').should == node_set(@c1)
      end

      it 'returns a NodeSet using multiple descendant expressions' do
        evaluate_xpath(@document, 'descendant-or-self::a/descendant-or-self::*')
          .should == node_set(@a1, @b1, @b2, @c1)
      end

      it 'returns a NodeSet containing a descendant with an attribute' do
        evaluate_xpath(@document, 'descendant-or-self::c[@class="x"]')
          .should == node_set(@c1)
      end

      it 'returns a NodeSet containing a descendant relative to a node' do
        evaluate_xpath(@document, 'a/descendant-or-self::b')
          .should == node_set(@b1, @b2)
      end

      it 'returns a NodeSet containing the context node' do
        evaluate_xpath(@document, 'descendant-or-self::a')
          .should == node_set(@a1)
      end

      it 'returns a NodeSet containing the context node relative to a node' do
        evaluate_xpath(@document, 'a/b/b/c/descendant-or-self::c')
          .should == node_set(@c1)
      end

      it 'returns a NodeSet containing the first descendant' do
        evaluate_xpath(@document, 'descendant-or-self::b[1]')
          .should == node_set(@b1)
      end

      it 'returns an empty NodeSet for a non existing descendant' do
        evaluate_xpath(@document, 'descendant-or-self::foobar')
          .should == node_set
      end

      describe 'relative to a node' do
        it 'returns a NodeSet containing a node and its descendants' do
          evaluate_xpath(@b1, 'descendant-or-self::b')
            .should == node_set(@b1, @b2)
        end

        it 'returns a NodeSet containing only the node itself' do
          evaluate_xpath(@c1, 'descendant-or-self::c').should == node_set(@c1)
        end
      end
    end

    describe 'using the shorthand syntax' do
      it 'returns a NodeSet containing all <b> nodes' do
        evaluate_xpath(@document, '//b').should == node_set(@b1, @b2)
      end

      it 'returns a NodeSet containing all the descendants of <a>' do
        evaluate_xpath(@document, '//a//*').should == node_set(@b1, @b2, @c1)
      end

      it 'returns a NodeSet containing all <b> nodes in an <a> node' do
        evaluate_xpath(@document, '//a/b').should == node_set(@b1)
      end

      describe 'relative to a node' do
        it 'returns a NodeSet containing all <b> nodes' do
          evaluate_xpath(@c1, '//b').should == node_set(@b1, @b2)
        end
      end
    end
  end
end
