require_relative '../profile_helper'

xml    = read_big_xml
parser = Oga::XML::PullParser.new(xml)

profile_memory('pull_parser/big_xml')

parser.parse { |node| }
