require 'spec_helper'

describe Oga::Parser do
  context 'HTML void elements' do
    example 'parse a void element that omits the closing /' do
      parse_html('<link>').should == s(
        :document,
        s(:element, nil, 'link', nil, nil)
      )
    end

    example 'parse a void element inside another element' do
      parse_html('<head><link></head>').should == s(
        :document,
        s(:element, nil, 'head', nil, s(:element, nil, 'link', nil, nil))
      )
    end

    example 'parse a void element with attributes inside another element' do
      parse_html('<head><link href="foo.css"></head>').should == s(
        :document,
        s(
          :element,
          nil,
          'head',
          nil,
          s(
            :element,
            nil,
            'link',
            s(:attributes, s(:attribute, 'href', 'foo.css')),
            nil
          )
        )
      )
    end

    example 'parse a void element and a non void element in the same parent' do
      parse_html('<head><link><title>Foo</title></head>').should == s(
        :document,
        s(
          :element,
          nil,
          'head',
          nil,
          s(
            :element,
            nil,
            'link',
            nil,
            nil
          ),
          s(
            :element,
            nil,
            'title',
            nil,
            s(:text, 'Foo')
          )
        )
      )
    end
  end
end
