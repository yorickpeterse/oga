require 'spec_helper'

describe Oga::CSS::Parser do
  context 'pseudo classes' do
    example 'parse the :root pseudo class' do
      parse_css('x:root').should == s(:pseudo, 'root', s(:test, nil, 'x'))
    end

    example 'parse the :nth-child pseudo class' do
      parse_css('x:nth-child(2)').should == s(
        :pseudo,
        'nth-child',
        s(:test, nil, 'x'),
        s(:int, 2)
      )
    end
  end
end
