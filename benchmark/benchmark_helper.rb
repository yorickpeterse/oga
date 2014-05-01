require 'benchmark'
require 'benchmark/ips'

require_relative '../lib/oga'

##
# Reads a big XML file and returns it as a String.
#
# @return [String]
#
def read_big_xml
  return File.read(File.expand_path('../fixtures/big.xml', __FILE__))
end

##
# Reads a normal sized HTML fixture.
#
# @return [String]
#
def read_html
  return File.read(File.expand_path('../fixtures/gist.html', __FILE__))
end
