require 'spec_helper'

describe Oga::Parser do
  context 'cdata tags' do
    example 'parse a cdata tag' do
      parse_html('<![CDATA[foo]]>').should == s(:document, s(:cdata, 'foo'))
    end

    example 'parse an element inside a cdata tag' do
      parse_html('<![CDATA[<p>foo</p>]]>').should == s(
        :document,
        s(:cdata, '<p>foo</p>')
      )
    end

    example 'parse double brackets inside a cdata tag' do
      parse_html('<![CDATA[]]]]>').should == s(:document, s(:cdata, ']]'))
    end
  end
end
