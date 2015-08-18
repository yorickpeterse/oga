require 'bundler/setup'
require 'timeout'
require 'stringio'
require 'oga'

Thread.abort_on_exception = true

##
# Returns memory usage in bytes. If /proc exists it is used, otherwise it falls
# back to `ps`.
#
# @return [Fixnum]
#
def memory_usage
  if File.exists?('/proc')
    kb = File.read('/proc/self/status').match(/VmRSS:\s+(\d+)/)[1].to_i
  else
    kb = `ps -o rss= #{Process.pid}`.strip.to_i
  end

  return kb * 1024
end

##
# Returns a File instance pointing to the sample XML file.
#
# @return [File]
#
def big_xml_file
  path = File.expand_path('../../benchmark/fixtures/big.xml', __FILE__)

  return File.open(path, 'r')
end

##
# Reads a big XML file and returns it as a String.
#
# @return [String]
#
def read_big_xml
  return big_xml_file.read
end

##
# Runs the specified block for at least N seconds while profiling memory usage
# at semi random intervals.
#
# @param [String] name The name of the samples file.
# @param [String] duration The amount of seconds to run.
#
def profile_memory(name, duration = 60)
  monitor = true
  threads = []

  threads << Thread.new do
    puts 'Starting sampler...'

    path        = File.expand_path("../samples/#{name}.txt", __FILE__)
    handle      = File.open(path, 'w')
    handle.sync = true
    start_time  = Time.now

    while monitor
      usage    = memory_usage
      usage_mb = (usage / 1024 / 1024).round(2)
      runtime  = Time.now - start_time

      handle.write("#{runtime} #{usage}\n")

      puts "#{usage_mb} MB"

      sleep(rand)
    end

    puts 'Stopping sampler...'

    handle.close
  end

  threads << Thread.new do
    start = Time.now

    begin
      Timeout.timeout(duration) { loop { yield} }
    rescue Timeout::Error
      diff    = Time.now - start
      monitor = false

      puts "Finished running after #{diff.round(3)} seconds"
    end
  end

  threads.each(&:join)
end
