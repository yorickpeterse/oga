require 'spec_helper'

describe Oga::XPath::Parser do
  context 'operator precedence' do
    example 'parse "A or B or C"' do
      parse_xpath('A or B or C').should == s(
        :path,
        s(
          :or,
          s(:or, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A and B and C"' do
      parse_xpath('A and B and C').should == s(
        :path,
        s(
          :and,
          s(:and, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A = B = C"' do
      parse_xpath('A = B = C').should == s(
        :path,
        s(
          :eq,
          s(:eq, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A != B != C"' do
      parse_xpath('A != B != C').should == s(
        :path,
        s(
          :neq,
          s(:neq, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A <= B <= C"' do
      parse_xpath('A <= B <= C').should == s(
        :path,
        s(
          :lte,
          s(:lte, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A < B < C"' do
      parse_xpath('A < B < C').should == s(
        :path,
        s(
          :lt,
          s(:lt, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A >= B >= C"' do
      parse_xpath('A >= B >= C').should == s(
        :path,
        s(
          :gte,
          s(:gte, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A > B > C"' do
      parse_xpath('A > B > C').should == s(
        :path,
        s(
          :gt,
          s(:gt, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A or B and C"' do
      parse_xpath('A or B and C').should == s(
        :path,
        s(
          :and,
          s(:or, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A and B = C"' do
      parse_xpath('A and B = C').should == s(
        :path,
        s(
          :and,
          s(:test, nil, 'A'),
          s(:eq, s(:test, nil, 'B'), s(:test, nil, 'C'))
        )
      )
    end

    example 'parse "A = B < C"' do
      parse_xpath('A = B < C').should == s(
        :path,
        s(
          :lt,
          s(:eq, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end

    example 'parse "A < B | C"' do
      parse_xpath('A < B | C').should == s(
        :path,
        s(
          :lt,
          s(:test, nil, 'A'),
          s(:pipe, s(:test, nil, 'B'), s(:test, nil, 'C'))
        )
      )
    end

    example 'parse "A > B or C"' do
      parse_xpath('A > B or C').should == s(
        :path,
        s(
          :or,
          s(:gt, s(:test, nil, 'A'), s(:test, nil, 'B')),
          s(:test, nil, 'C')
        )
      )
    end
  end
end
