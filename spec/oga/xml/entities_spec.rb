require 'spec_helper'

describe Oga::XML::Entities do
  describe 'decode' do
    it 'decodes &lt; into <' do
      expect(described_class.decode('&lt;')).to eq('<')
    end

    it 'decodes &gt; into >' do
      expect(described_class.decode('&gt;')).to eq('>')
    end

    it "decodes &apos; into '" do
      expect(described_class.decode('&apos;')).to eq("'")
    end

    it 'decodes &quot; into "' do
      expect(described_class.decode('&quot;')).to eq('"')
    end

    it 'decodes &amp; into &' do
      expect(described_class.decode('&amp;')).to eq('&')
    end

    it 'decodes &#60; into <' do
      expect(described_class.decode('&#60;')).to eq('<')
    end

    it 'decodes &#62; into >' do
      expect(described_class.decode('&#62;')).to eq('>')
    end

    it "decodes &#39; into '" do
      expect(described_class.decode('&#39;')).to eq("'")
    end

    it 'decodes &#34; into "' do
      expect(described_class.decode('&#34;')).to eq('"')
    end

    it 'decodes &#38; into &' do
      expect(described_class.decode('&#38;')).to eq('&')
    end

    it 'decodes &#38;#60; into &#60;' do
      expect(described_class.decode('&#38;#60;')).to eq('&#60;')
    end

    it 'decodes &#38;#38; into &#38;' do
      expect(described_class.decode('&#38;#38;')).to eq('&#38;')
    end

    it 'decodes &amp;gt; into &gt;' do
      expect(described_class.decode('&amp;gt;')).to eq('&gt;')
    end

    it 'decodes &amp;&amp;gt; into &>' do
      expect(described_class.decode('&amp;&amp;gt;')).to eq('&&gt;')
    end

    it 'decodes &amp;lt; into <' do
      expect(described_class.decode('&amp;lt;')).to eq('&lt;')
    end

    it 'decodes &amp;&amp;lt; into &<' do
      expect(described_class.decode('&amp;&amp;lt;')).to eq('&&lt;')
    end

    it 'decodes &#x3C; into <' do
      expect(described_class.decode('&#x3C;')).to eq('<')
    end

    it 'decodes numeric entities starting with a 0' do
      expect(described_class.decode('&#038;')).to eq('&')
    end

    it 'preserves entity-like tokens' do
      expect(described_class.decode('&#TAB;')).to eq('&#TAB;')
    end

    it 'preserves entity-like hex tokens' do
      expect(described_class.decode('&#x;')).to eq('&#x;')
    end

    it 'preserves entity-like letters in non-hex mode' do
      expect(described_class.decode('&#123A;')).to eq('&#123A;')
    end

    it "preserves numeric entities when they can't be decoded" do
      expect(described_class.decode('&#2013265920;')).to eq('&#2013265920;')
    end

    it "preserves hex entities when they can't be decoded" do
      expect(described_class.decode('&#xffffff;')).to eq('&#xffffff;')
    end
  end

  describe 'encode' do
    it 'encodes & as &amp;' do
      expect(described_class.encode('&')).to eq('&amp;')
    end

    it 'does not encode double quotes' do
      expect(described_class.encode('"')).to eq('"')
    end

    it 'does not encode single quotes' do
      expect(described_class.encode("'")).to eq("'")
    end

    it 'encodes < as &lt;' do
      expect(described_class.encode('<')).to eq('&lt;')
    end

    it 'encodes > as &gt;' do
      expect(described_class.encode('>')).to eq('&gt;')
    end

    it 'encodes &gt; as &amp;gt;' do
      expect(described_class.encode('&gt;')).to eq('&amp;gt;')
    end

    it 'encodes &lt; as &amp;lt;' do
      expect(described_class.encode('&lt;')).to eq('&amp;lt;')
    end
  end

  describe 'encode_attribute' do
    it 'encodes & as &amp;' do
      expect(described_class.encode_attribute('&')).to eq('&amp;')
    end

    it 'encodes > as &gt;' do
      expect(described_class.encode_attribute('>')).to eq('&gt;')
    end

    it 'encodes < as &gt;' do
      expect(described_class.encode_attribute('<')).to eq('&lt;')
    end

    it 'encodes a single quote as &apos;' do
      expect(described_class.encode_attribute("'")).to eq('&apos;')
    end

    it 'encodes a double quote as &quot;' do
      expect(described_class.encode_attribute('"')).to eq('&quot;')
    end
  end
end
