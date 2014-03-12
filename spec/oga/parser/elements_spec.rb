require 'spec_helper'

describe Oga::Parser do
  context 'elements' do
    example 'parse an empty element' do
      parse_html('<p></p>').should == s(:document, s(:element, nil, 'p'))
    end

    example 'parse an element with text' do
      parse_html('<p>foo</p>').should == s(
        :document,
        s(:element, nil, 'p', nil, s(:text, 'foo'))
      )
    end

    example 'parse an element with a single attribute' do
      parse_html('<p foo></p>').should == s(
        :document,
        s(:element, nil, 'p', s(:attributes, s(:attribute, 'foo')))
      )
    end

    example 'parse an element with a single attribute with a value' do
      parse_html('<p foo="bar"></p>').should == s(
        :document,
        s(:element, nil, 'p', s(:attributes, s(:attribute, 'foo', 'bar')))
      )
    end

    example 'parse an element with multiple attributes' do
      parse_html('<p foo="bar" baz="bad"></p>').should == s(
        :document,
        s(
          :element,
          nil,
          'p',
          s(
            :attributes,
            s(:attribute, 'foo', 'bar'),
            s(:attribute, 'baz', 'bad')
          )
        )
      )
    end

    example 'parse an element with text and attributes' do
      parse_html('<p class="foo">Bar</p>').should == s(
        :document,
        s(
          :element,
          nil,
          'p',
          s(:attributes, s(:attribute, 'class', 'foo')),
          s(:text, 'Bar')
        )
      )
    end

    example 'parse an element with a namespace' do
      parse_html('<foo:p></p>').should == s(
        :document,
        s(:element, 'foo', 'p')
      )
    end

    example 'parse an element with a namespace and an attribute' do
      parse_html('<foo:p class="bar"></p>').should == s(
        :document,
        s(:element, 'foo', 'p', s(:attributes, s(:attribute, 'class', 'bar')))
      )
    end
  end
end
