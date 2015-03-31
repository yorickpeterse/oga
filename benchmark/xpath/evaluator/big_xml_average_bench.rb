require_relative '../../benchmark_helper'

doc = Oga.parse_xml(big_xml_file)

measure_average do
  doc.xpath('descendant-or-self::location')
end
