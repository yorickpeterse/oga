require_relative '../profile_helper'

xml    = read_big_xml
parser = Oga::XML::Parser.new(xml)

profile_memory('parser/big_xml')

parser.parse
