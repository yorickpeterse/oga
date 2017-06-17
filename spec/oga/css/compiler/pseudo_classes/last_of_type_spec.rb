require 'spec_helper'

describe 'CSS selector evaluation' do
  describe ':last-of-type pseudo class' do
    before do
      @document = parse(<<-EOF)
<root>
  <a id="1" />
  <a id="2">
    <a id="3" />
    <a id="4" />
  </a>
</root>
      EOF

      @a2 = @document.at_xpath('root/a[2]')
      @a4 = @document.at_xpath('root/a[2]/a[2]')
    end

    it 'returns a node set containing all last <a> nodes' do
      expect(evaluate_css(@document, 'root a:last-of-type'))
        .to eq(node_set(@a2, @a4))
    end
  end
end
