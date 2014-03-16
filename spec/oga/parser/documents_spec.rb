require 'spec_helper'

describe Oga::Parser do
  context 'HTML documents' do
    example 'parse a basic HTML document' do
      html = <<-EOF
<!DOCTYPE html>
<html>
<head>
<title>Title</title>
</head>
<body></body>
</html>
      EOF

      parse(html).should == s(
        :document,
        s(:doctype),
        s(:text, "\n"),

        # <html>
        s(
          :element,
          nil,
          'html',
          nil,

          s(:text, "\n"),

          # <head>
          s(
            :element,
            nil,
            'head',
            nil,

            s(:text, "\n"),

            # <title>
            s(
              :element,
              nil,
              'title',
              nil,
              s(:text, 'Title')
            ),

            s(:text, "\n")
          ),

          # <body>
          s(:text, "\n"),
          s(:element, nil, 'body', nil, nil),
          s(:text, "\n")
        ),
        s(:text, "\n")
      )
    end
  end
end
