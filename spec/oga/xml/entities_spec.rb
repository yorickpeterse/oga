require 'spec_helper'

describe Oga::XML::Entities do
  context 'decode' do
    example 'decode &amp; into &' do
      described_class.decode('&amp;').should == '&'
    end

    example 'decode &lt; into <' do
      described_class.decode('&lt;').should == '<'
    end

    example 'decode &gt; into >' do
      described_class.decode('&gt;').should == '>'
    end
  end

  context 'encode' do
    example 'encode & as &amp;' do
      described_class.encode('&').should == '&amp;'
    end

    example 'encode < as &lt;' do
      described_class.encode('<').should == '&lt;'
    end

    example 'encode > as &gt;' do
      described_class.encode('>').should == '&gt;'
    end
  end
end
