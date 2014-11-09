require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'descendant-or-self axis' do
    before do
      @document = parse('<a><b><b><c class="x"></c></b></b></a>')

      @a1 = @document.children[0]
      @b1 = @a1.children[0]
      @b2 = @b1.children[0]
      @c1 = @b2.children[0]
    end

    example 'return a node set containing a direct descendant' do
      evaluate_xpath(@document, 'descendant-or-self::b')
        .should == node_set(@b1, @b2)
    end

    example 'return a node set containing a nested descendant' do
      evaluate_xpath(@document, 'descendant-or-self::c').should == node_set(@c1)
    end

    example 'return a node set using multiple descendant expressions' do
      evaluate_xpath(@document, 'descendant-or-self::a/descendant-or-self::*')
        .should == node_set(@a1, @b1, @b2, @c1)
    end

    example 'return a node set containing a descendant with an attribute' do
      evaluate_xpath(@document, 'descendant-or-self::c[@class="x"]')
        .should == node_set(@c1)
    end

    example 'return a node set containing a descendant relative to a node' do
      evaluate_xpath(@document, 'a/descendant-or-self::b')
        .should == node_set(@b1, @b2)
    end

    example 'return a node set containing the context node' do
      evaluate_xpath(@document, 'descendant-or-self::a')
        .should == node_set(@a1)
    end

    example 'return a node set containing the context node relative to a node' do
      evaluate_xpath(@document, 'a/b/b/c/descendant-or-self::c')
        .should == node_set(@c1)
    end

    example 'return an empty node set for a non existing descendant' do
      evaluate_xpath(@document, 'descendant-or-self::foobar').should == node_set
    end

    example 'return a node set containing a descendant using the short form' do
      evaluate_xpath(@document, '//b').should == node_set(@b1, @b2)
    end

    example 'return a node set containing a nested descendant using the short form' do
      evaluate_xpath(@document, '//a//*').should == node_set(@b1, @b2, @c1)
    end

    example 'return a node set containing children of a descendant' do
      evaluate_xpath(@document, '//a/b').should == node_set(@b1)
    end
  end
end
