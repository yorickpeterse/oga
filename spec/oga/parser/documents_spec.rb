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
          :html,
          nil,
          nil,

          s(:text, "\n"),

          # <head>
          s(
            :head,
            nil,
            nil,

            s(:text, "\n"),

            # <title>
            s(
              :title,
              nil,
              nil,
              s(:text, 'Title')
            ),

            s(:text, "\n")
          ),

          # <body>
          s(:text, "\n"),
          s(:body, nil, nil, nil),
          s(:text, "\n")
        ),
        s(:text, "\n")
      )
    end
  end
end
