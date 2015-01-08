require 'spec_helper'

describe Oga::XML::Entities do
  describe 'decode' do
    it 'decodes &lt; into <' do
      described_class.decode('&lt;').should == '<'
    end

    it 'decodes &gt; into >' do
      described_class.decode('&gt;').should == '>'
    end

    it "decodes &apos; into '" do
      described_class.decode('&apos;').should == "'"
    end

    it 'decodes &quot; into "' do
      described_class.decode('&quot;').should == '"'
    end

    it 'decodes &amp; into &' do
      described_class.decode('&amp;').should == '&'
    end

    it 'decodes &#60; into <' do
      described_class.decode('&#60;').should == '<'
    end

    it 'decodes &#62; into >' do
      described_class.decode('&#62;').should == '>'
    end

    it "decodes &#39; into '" do
      described_class.decode('&#39;').should == "'"
    end

    it 'decodes &#34; into "' do
      described_class.decode('&#34;').should == '"'
    end

    it 'decodes &#38; into &' do
      described_class.decode('&#38;').should == '&'
    end

    it 'decodes &#38;#60; into &#60;' do
      described_class.decode('&#38;#60;').should == '&#60;'
    end

    it 'decodes &#38;#38; into &#38;' do
      described_class.decode('&#38;#38;').should == '&#38;'
    end

    it 'decodes &amp;gt; into &gt;' do
      described_class.decode('&amp;gt;').should == '&gt;'
    end

    it 'decodes &amp;&amp;gt; into &>' do
      described_class.decode('&amp;&amp;gt;').should == '&&gt;'
    end

    it 'decodes &amp;lt; into <' do
      described_class.decode('&amp;lt;').should == '&lt;'
    end

    it 'decodes &amp;&amp;lt; into &<' do
      described_class.decode('&amp;&amp;lt;').should == '&&lt;'
    end
  end

  describe 'encode' do
    it 'encodes & as &amp;' do
      described_class.encode('&').should == '&amp;'
    end

    it 'encodes " as &quot;' do
      described_class.encode('"').should == '&quot;'
    end

    it "encodes ' as &apos;" do
      described_class.encode("'").should == '&apos;'
    end

    it 'encodes < as &lt;' do
      described_class.encode('<').should == '&lt;'
    end

    it 'encodes > as &gt;' do
      described_class.encode('>').should == '&gt;'
    end

    it 'encodes &gt; as &amp;gt;' do
      described_class.encode('&gt;').should == '&amp;gt;'
    end

    it 'encodes &lt; as &amp;lt;' do
      described_class.encode('&lt;').should == '&amp;lt;'
    end
  end
end
