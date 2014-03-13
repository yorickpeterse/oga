require 'spec_helper'

describe Oga::Parser do
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
        [:T_DOCTYPE_START, '<!DOCTYPE html', 1, 1],
        [:T_DOCTYPE_END, '>', 1, 15],
        [:T_TEXT, "\n", 1, 16],

        # <html>
        [:T_ELEM_OPEN, nil, 2, 1],
        [:T_ELEM_NAME, 'html', 2, 2],
        [:T_TEXT, "\n", 2, 7],

        # <head>
        [:T_ELEM_OPEN, nil, 3, 1],
        [:T_ELEM_NAME, 'head', 3, 2],
        [:T_TEXT, "\n", 3, 7],

        # <title>Title</title>
        [:T_ELEM_OPEN, nil, 4, 1],
        [:T_ELEM_NAME, 'title', 4, 2],
        [:T_TEXT, 'Title', 4, 8],
        [:T_ELEM_CLOSE, nil, 4, 13],
        [:T_TEXT, "\n", 4, 21],

        # </head>
        [:T_ELEM_CLOSE, nil, 5, 1],
        [:T_TEXT, "\n", 5, 8],

        # <body></body>
        [:T_ELEM_OPEN, nil, 6, 1],
        [:T_ELEM_NAME, 'body', 6, 2],
        [:T_ELEM_CLOSE, nil, 6, 7],
        [:T_TEXT, "\n", 6, 14],

        # </html>
        [:T_ELEM_CLOSE, nil, 7, 1],
        [:T_TEXT, "\n", 7, 8]
      ]
    end
  end
end
