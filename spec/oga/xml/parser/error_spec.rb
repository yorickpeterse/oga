require 'spec_helper'

describe Oga::XML::Parser do
  context 'raising syntax errors' do
    before do
      @invalid_xml = <<-EOF.strip
<person>
  <name>Alice</name>
  <age>25
  <nationality>Dutch</nationality>
</person>
      EOF
    end

    example 'raise a Racc::ParseError' do
      expect { parse(@invalid_xml) }.to raise_error(Racc::ParseError)
    end

    example 'include the offending input when using String as input' do
      # Racc basically reports errors at the last moment instead of where they
      # *actually* occur.
      partial = <<-EOF.strip
   1. <person>
   2. <name>Alice</name>
   3. <age>25
   4. <nationality>Dutch</nationality>
=> 5. </person>
      EOF

      parse_error(@invalid_xml).should =~ /#{partial}/
    end

    example 'include the offending input when using IO as input' do
      # Racc basically reports errors at the last moment instead of where they
      # *actually* occur.
      partial = <<-EOF.strip
   1. <person>
   2. <name>Alice</name>
   3. <age>25
   4. <nationality>Dutch</nationality>
=> 5. </person>
      EOF

      parse_error(StringIO.new(@invalid_xml)).should =~ /#{partial}/
    end

    example 'use more friendly error messages when available' do
      parse_error('</foo>').should =~ /Unexpected element closing tag/
    end
  end
end
