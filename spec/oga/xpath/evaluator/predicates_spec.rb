require 'spec_helper'

describe Oga::XPath::Evaluator do
  context 'predicates' do
    before do
      @document = parse(<<-EOF)
<root>
  <a>10</a>
  <b>
    <a>20</a>
    <a>30</3>
  </b>
</root>
      EOF

      @a1 = @document.at_xpath('root/a[1]')
      @a2 = @document.at_xpath('root/b/a[1]')
    end

    example 'return a node set containing all first <a> nodes' do
      evaluate_xpath(@document, 'descendant-or-self::node()/a[1]')
        .should == node_set(@a1, @a2)
    end
  end
end
