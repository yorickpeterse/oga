require 'ast'
require 'set'

# Load these first so that the native extensions don't have to define the
# Oga::XML namespace.
require_relative 'oga/xml/lexer'
require_relative 'oga/xml/parser'
require_relative 'oga/xml/pull_parser'

require_relative 'liboga'

#:nocov:
if RUBY_PLATFORM == 'java'
  org.liboga.Liboga.load(JRuby.runtime)
end
#:nocov:

require_relative 'oga/xml/node'
require_relative 'oga/xml/element'
require_relative 'oga/xml/document'
require_relative 'oga/xml/text'
require_relative 'oga/xml/comment'
require_relative 'oga/xml/cdata'
require_relative 'oga/xml/xml_declaration'
require_relative 'oga/xml/doctype'

require_relative 'oga/html/parser'

require_relative 'oga/xpath/node'
require_relative 'oga/xpath/lexer'
require_relative 'oga/xpath/parser'
