require 'set'

require_relative 'oga/xml/lexer'
require_relative 'oga/xml/parser'
require_relative 'oga/xml/pull_parser'

require_relative 'liboga'

# FIXME: it looks like this should not be needed but stuff doesn't load without
# it.
if RUBY_ENGINE == 'jruby'
  org.liboga.LibogaService.new.basicLoad(JRuby.runtime)
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
