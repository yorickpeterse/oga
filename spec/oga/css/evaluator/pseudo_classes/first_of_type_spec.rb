require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':first-of-type pseudo class' do
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

      @a1 = @document.at_xpath('root/a[1]')
      @a3 = @document.at_xpath('root/a[2]/a[1]')
    end

    example 'return a node set containing all first <a> nodes' do
      evaluate_css(@document, 'root a:first-of-type')
        .should == node_set(@a1, @a3)
    end
  end
end
