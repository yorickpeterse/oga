require_relative '../lib/oga'

##
# Returns memory usage in bytes. This relies on the /proc filesystem, it won't
# work without it.
#
# @return [Fixnum]
#
def memory_usage
  return File.read('/proc/self/status').match(/VmRSS:\s+(\d+)/)[1].to_i * 1024
end

##
# Reads a big XML file and returns it as a String.
#
# @return [String]
#
def read_big_xml
  return File.read(File.expand_path('../../benchmark/fixtures/big.xml', __FILE__))
end

##
# Writes memory samples to a file until the thread is killed.
#
# @param [String] name The name of the samples file.
# @param [Fixnum] interval The sample interval. The default is 200 ms.
# @return [Thread]
#
def profile_memory(name, interval = 0.2)
  return Thread.new do
    path        = File.expand_path("../samples/#{name}.txt", __FILE__)
    handle      = File.open(path, 'w')
    handle.sync = true

    loop do
      handle.write("#{memory_usage}\n")

      sleep(interval)
    end
  end
end
