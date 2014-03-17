require 'spec_helper'

describe Oga::Parser do
  context 'HTML void elements' do
    example 'parse a void element that omits the closing /' do
      parse('<link>', :html => true).should == s(
        :document,
        s(:link, nil, nil, nil)
      )
    end

    example 'parse a void element inside another element' do
      parse('<head><link></head>', :html => true).should == s(
        :document,
        s(:head, nil, nil, s(:link, nil, nil, nil))
      )
    end

    example 'parse a void element with attributes inside another element' do
      parse('<head><link href="foo.css"></head>', :html => true).should == s(
        :document,
        s(
          :head,
          nil,
          nil,
          s(
            :link,
            nil,
            s(:attributes, s(:attribute, 'href', 'foo.css')),
            nil
          )
        )
      )
    end

    example 'parse a void element and a non void element in the same parent' do
      parse('<head><link><title>Foo</title></head>', :html => true).should == s(
        :document,
        s(
          :head,
          nil,
          nil,
          s(:link, nil, nil, nil),
          s(:title, nil, nil, s(:text, 'Foo'))
        )
      )
    end
  end
end
