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

    example 'decode &quot; into "' do
      described_class.decode('&quot;').should == '"'
    end

    example 'decode &amp;gt; into &gt;' do
      described_class.decode('&amp;gt;').should == '&gt;'
    end

    example 'decode &amp;&amp;gt; into &>' do
      described_class.decode('&amp;&amp;gt;').should == '&&gt;'
    end

    example 'decode &amp;lt; into <' do
      described_class.decode('&amp;lt;').should == '&lt;'
    end

    example 'decode &amp;&amp;lt; into &<' do
      described_class.decode('&amp;&amp;lt;').should == '&&lt;'
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

    example 'encode " as &quot;' do
      described_class.encode('"').should == '&quot;'
    end

    example 'encode &gt; as &amp;gt;' do
      described_class.encode('&gt;').should == '&amp;gt;'
    end

    example 'encode &lt; as &amp;lt;' do
      described_class.encode('&lt;').should == '&amp;lt;'
    end
  end
end
