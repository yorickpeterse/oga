require 'spec_helper'

describe Oga::XML::Lexer do
  context 'HTML documents' do
    example 'lex a basic HTML document' do
      html = <<-EOF
<!DOCTYPE html>
<html>
<head>
<title>Title</title>
</head>
<body></body>
</html>
      EOF

      lex(html).should == [
        [:T_DOCTYPE_START, nil, 1],
        [:T_DOCTYPE_NAME, 'html', 1],
        [:T_DOCTYPE_END, nil, 1],
        [:T_TEXT, "\n", 1],

        # <html>
        [:T_ELEM_START, nil, 2],
        [:T_ELEM_NAME, 'html', 2],
        [:T_TEXT, "\n", 2],

        # <head>
        [:T_ELEM_START, nil, 3],
        [:T_ELEM_NAME, 'head', 3],
        [:T_TEXT, "\n", 3],

        # <title>Title</title>
        [:T_ELEM_START, nil, 4],
        [:T_ELEM_NAME, 'title', 4],
        [:T_TEXT, 'Title', 4],
        [:T_ELEM_END, nil, 4],
        [:T_TEXT, "\n", 4],

        # </head>
        [:T_ELEM_END, nil, 5],
        [:T_TEXT, "\n", 5],

        # <body></body>
        [:T_ELEM_START, nil, 6],
        [:T_ELEM_NAME, 'body', 6],
        [:T_ELEM_END, nil, 6],
        [:T_TEXT, "\n", 6],

        # </html>
        [:T_ELEM_END, nil, 7],
        [:T_TEXT, "\n", 7]
      ]
    end
  end
end
