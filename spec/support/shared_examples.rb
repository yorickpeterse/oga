shared_examples :node_set do |options|
  example 'return a NodeSet instance' do
    @set.is_a?(Oga::XML::NodeSet).should == true
  end

  example 'return the right amount of rows' do
    @set.length.should == options[:length]
  end
end

shared_examples :empty_node_set do
  example 'return a NodeSet instance' do
    @set.is_a?(Oga::XML::NodeSet).should == true
  end

  example 'return the right amount of rows' do
    @set.empty?.should == true
  end
end
