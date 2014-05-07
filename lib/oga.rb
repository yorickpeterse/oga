require 'set'

# Load these first so that the native extensions don't have to define the
# Oga::XML namespace.
require_relative 'oga/xml/lexer'
require_relative 'oga/xml/parser'
require_relative 'oga/xml/pull_parser'

# Load native ext for lexer
case RUBY_PLATFORM
when 'java'
  require 'liboga.jar'
  org.liboga.xml.Lexer.load(JRuby.runtime);
else
  require 'liboga'
end

require_relative 'oga/xml/node'
require_relative 'oga/xml/element'
require_relative 'oga/xml/document'
require_relative 'oga/xml/text'
require_relative 'oga/xml/comment'
require_relative 'oga/xml/cdata'
require_relative 'oga/xml/xml_declaration'
require_relative 'oga/xml/doctype'

require_relative 'oga/html/parser'
