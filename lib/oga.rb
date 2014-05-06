require 'set'

# Load these first so that the native extensions don't have to define the
# Oga::XML namespace.
require_relative 'oga/xml/lexer'
require_relative 'oga/xml/parser'
require_relative 'oga/xml/pull_parser'

# JRuby is dumb as a brick and can only load .jar files using require() when
# ./lib is in the LOAD_PATH. require_relative, or any other form that uses
# absolute paths, does not work.
unless $:.include?(File.expand_path('../', __FILE__))
  $:.unshift(File.expand_path('../', __FILE__))
end

require 'liboga'

require_relative 'oga/xml/node'
require_relative 'oga/xml/element'
require_relative 'oga/xml/document'
require_relative 'oga/xml/text'
require_relative 'oga/xml/comment'
require_relative 'oga/xml/cdata'
require_relative 'oga/xml/xml_declaration'
require_relative 'oga/xml/doctype'

require_relative 'oga/html/parser'
