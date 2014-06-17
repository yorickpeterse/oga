require 'spec_helper'

describe Oga::XPath::Parser do
  context 'predicates' do
    example 'parse a single predicate' do
      parse_xpath('/foo[@class="bar"]').should == s(
        :absolute,
        s(
          :path,
          s(
            :test,
            nil,
            'foo',
            s(
              :path,
              s(
                :eq,
                s(:axis, 'attribute', s(:test, nil, 'class')),
                s(:string, 'bar')
              )
            )
          )
        )
      )
    end

    example 'parse a predicate using the or operator' do
      parse_xpath('/foo[@class="bar" or @class="baz"]').should == s(
        :absolute,
        s(
          :path,
          s(
            :test,
            nil,
            'foo',
            s(
              :path,
              s(
                :or,
                s(
                  :eq,
                  s(:axis, 'attribute', s(:test, nil, 'class')),
                  s(:string, 'bar')
                ),
                s(
                  :eq,
                  s(:axis, 'attribute', s(:test, nil, 'class')),
                  s(:string, 'baz')
                )
              )
            )
          )
        )
      )
    end
  end
end
