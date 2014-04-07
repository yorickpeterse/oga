require 'spec_helper'

describe Oga::XML::Parser do
  context 'XML declaration tags' do
    example 'parse an empty XML declaration tag' do
      parse('<?xml?>').should == s(:document, s(:xml_decl))
    end

    example 'parse an XML declaration tag' do
      parse('<?xml version="1.0" ?>').should == s(
        :document,
        s(:xml_decl, s(:attributes, s(:attribute, 'version', '1.0')))
      )
    end
  end
end
