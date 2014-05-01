require_relative '../profile_helper'

xml = read_big_xml

profile_memory('parser/big_xml') do
  Oga::XML::Parser.new(xml).parse
end
