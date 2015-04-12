require_relative '../../benchmark_helper'

doc = Oga.parse_xml(big_xml_file)

doc.each_node { }

measure_average do
  doc.each_node { }
end
