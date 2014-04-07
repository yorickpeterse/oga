require 'spec_helper'

describe Oga::XML::Parser do
  context 'cdata tags' do
    example 'parse an empty cdata tag' do
      parse('<![CDATA[]]>').should == s(:document, s(:cdata))
    end

    example 'parse a cdata tag' do
      parse('<![CDATA[foo]]>').should == s(:document, s(:cdata, 'foo'))
    end

    example 'parse an element inside a cdata tag' do
      parse('<![CDATA[<p>foo</p>]]>').should == s(
        :document,
        s(:cdata, '<p>foo</p>')
      )
    end

    example 'parse double brackets inside a cdata tag' do
      parse('<![CDATA[]]]]>').should == s(:document, s(:cdata, ']]'))
    end
  end
end
