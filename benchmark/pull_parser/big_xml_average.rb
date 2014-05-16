require_relative '../benchmark_helper'

xml = read_big_xml

measure_average do
  Oga::XML::PullParser.new(xml).parse { }
end
