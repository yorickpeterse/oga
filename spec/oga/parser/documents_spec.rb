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

      parse_html(html).should == s(
        :document,
        s(:doctype),

        # <html>
        s(
          :element,
          nil,
          'html',
          nil,

          # <head>
          s(
            :element,
            nil,
            'head',
            nil,

            # <title>
            s(
              :element,
              nil,
              'title',
              nil,
              s(:text, 'Title')
            )
          ),

          # <body>
          s(:element, nil, 'body', nil, nil)
        ),
        s(:text, "\n")
      )
    end
  end
end
