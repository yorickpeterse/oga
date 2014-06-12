require_relative '../../profile_helper'

xml = read_big_xml

profile_memory('xml/pull_parser/big_xml') do
  Oga::XML::PullParser.new(xml).parse { }
end

