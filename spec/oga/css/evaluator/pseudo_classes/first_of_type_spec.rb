require 'spec_helper'

describe 'CSS selector evaluation' do
  context ':first-of-type pseudo class' do
    before do
      @document = parse(<<-EOF)
<dl>
  <dt>foo</dt>
  <dd>
    <dl>
      <dt>bar</dt>
      <dd>baz</dd>
    </dl>
  </dd>
</dl>
      EOF

      @dt1 = @document.at_xpath('dl/dt')
      @dt2 = @document.at_xpath('dl/dd/dl/dt')
    end

    example 'return a node set containing all <dt> nodes' do
      evaluate_css(@document, 'dl dt:first-of-type')
        .should == node_set(@dt1, @dt2)
    end
  end
end
