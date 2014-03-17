require 'spec_helper'

describe Oga::Parser do
  context 'elements' do
    example 'parse an empty element' do
      parse('<p></p>').should == s(:document, s(:p, nil, nil, nil))
    end

    example 'parse an element with text' do
      parse('<p>foo</p>').should == s(
        :document,
        s(:p, nil, nil, s(:text, 'foo'))
      )
    end

    example 'parse an element with a single attribute' do
      parse('<p foo></p>').should == s(
        :document,
        s(:p, nil, s(:attributes, s(:attribute, 'foo')), nil)
      )
    end

    example 'parse an element with a single attribute with a value' do
      parse('<p foo="bar"></p>').should == s(
        :document,
        s(:p, nil, s(:attributes, s(:attribute, 'foo', 'bar')), nil)
      )
    end

    example 'parse an element with multiple attributes' do
      parse('<p foo="bar" baz="bad"></p>').should == s(
        :document,
        s(
          :p,
          nil,
          s(
            :attributes,
            s(:attribute, 'foo', 'bar'),
            s(:attribute, 'baz', 'bad')
          ),
          nil
        )
      )
    end

    example 'parse an element with text and attributes' do
      parse('<p class="foo">Bar</p>').should == s(
        :document,
        s(
          :p,
          nil,
          s(:attributes, s(:attribute, 'class', 'foo')),
          s(:text, 'Bar')
        )
      )
    end

    example 'parse an element with a namespace' do
      parse('<foo:p></p>').should == s(
        :document,
        s(:p, 'foo', nil, nil)
      )
    end

    example 'parse an element with a namespace and an attribute' do
      parse('<foo:p class="bar"></p>').should == s(
        :document,
        s(
          :p,
          'foo',
          s(:attributes, s(:attribute, 'class', 'bar')),
          nil
        )
      )
    end

    example 'parse an element nested inside another element' do
      parse('<p><a></a></p>').should == s(
        :document,
        s(:p, nil, nil, s(:a, nil, nil, nil))
      )
    end

    example 'parse an element with children text, element' do
      parse('<p>Foo<a>Bar</a></p>').should == s(
        :document,
        s(
          :p,
          nil,
          nil,
          s(:text, 'Foo'),
          s(:a, nil, nil, s(:text, 'Bar'))
        )
      )
    end

    example 'parse an element with children text, element, text' do
      parse('<p>Foo<a>Bar</a>Baz</p>').should == s(
        :document,
        s(
          :p,
          nil,
          nil,
          s(:text, 'Foo'),
          s(:a, nil, nil, s(:text, 'Bar')),
          s(:text, 'Baz')
        )
      )
    end

    example 'parse an element with children element, text' do
      parse('<p><a>Bar</a>Baz</p>').should == s(
        :document,
        s(
          :p,
          nil,
          nil,
          s(:a, nil, nil, s(:text, 'Bar')),
          s(:text, 'Baz')
        )
      )
    end

    example 'parse an element with children element, text, element' do
      parse('<p><a>Bar</a>Baz<span>Da</span></p>').should == s(
        :document,
        s(
          :p,
          nil,
          nil,
          s(:a, nil, nil, s(:text, 'Bar')),
          s(:text, 'Baz'),
          s(:span, nil, nil, s(:text, 'Da'))
        )
      )
    end
  end
end
