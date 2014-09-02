require 'spec_helper'

describe Oga::XML::Lexer do
  context 'lexing inline Javascript' do
    before do
      @javascript = <<-EOF.strip
(function()
{
  if ( some_number < 10 )
  {
    console.log('Hello');
  }
})();
      EOF
    end

    example 'lex inline Javascript' do
      lex("<script>\n#{@javascript}\n</script>").should == [
        [:T_ELEM_START, nil, 1],
        [:T_ELEM_NAME, 'script', 1],
        [:T_TEXT, "\n#{@javascript}\n", 1],
        [:T_ELEM_END, nil, 9]
      ]
    end
  end
end
