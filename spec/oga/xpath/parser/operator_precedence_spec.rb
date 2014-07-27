require 'spec_helper'

describe Oga::XPath::Parser do
  context 'operator precedence' do
    example 'parse "A or B or C"' do
      parse_xpath('A or B or C').should == s(
        :or,
        s(
          :or,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A and B and C"' do
      parse_xpath('A and B and C').should == s(
        :and,
        s(
          :and,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A = B = C"' do
      parse_xpath('A = B = C').should == s(
        :eq,
        s(
          :eq,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A != B != C"' do
      parse_xpath('A != B != C').should == s(
        :neq,
        s(
          :neq,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A <= B <= C"' do
      parse_xpath('A <= B <= C').should == s(
        :lte,
        s(
          :lte,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A < B < C"' do
      parse_xpath('A < B < C').should == s(
        :lt,
        s(
          :lt,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A >= B >= C"' do
      parse_xpath('A >= B >= C').should == s(
        :gte,
        s(
          :gte,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A > B > C"' do
      parse_xpath('A > B > C').should == s(
        :gt,
        s(
          :gt,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end

    example 'parse "A or B and C"' do
      parse_xpath('A or B and C').should == s(
        :or,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :and,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      )
    end

    example 'parse "A and B = C"' do
      parse_xpath('A and B = C').should == s(
        :and,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :eq,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      )
    end

    example 'parse "A = B < C"' do
      parse_xpath('A = B < C').should == s(
        :eq,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :lt,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      )
    end

    example 'parse "A < B | C"' do
      parse_xpath('A < B | C').should == s(
        :lt,
        s(:axis, 'child', s(:test, nil, 'A')),
        s(
          :pipe,
          s(:axis, 'child', s(:test, nil, 'B')),
          s(:axis, 'child', s(:test, nil, 'C'))
        )
      )
    end

    example 'parse "A > B or C"' do
      parse_xpath('A > B or C').should == s(
        :or,
        s(
          :gt,
          s(:axis, 'child', s(:test, nil, 'A')),
          s(:axis, 'child', s(:test, nil, 'B'))
        ),
        s(:axis, 'child', s(:test, nil, 'C'))
      )
    end
  end
end
