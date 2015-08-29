require_relative '../../benchmark_helper'

doc = Oga.parse_xml(big_xml_file)

# Warm up any caches
doc.xpath('descendant-or-self::location')

measure_average do
  doc.xpath('descendant-or-self::location')
end
