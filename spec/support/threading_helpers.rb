module Oga
  module ThreadingHelpers
    ##
    # Iterates over the enumerable using a separate thread for every value. This
    # method waits for all threads to complete before returning.
    #
    # @example
    #  each_in_parallel([10, 20]) do |value|
    #    puts value
    #  end
    #
    # @param [Enumerable] enumerable
    # @yieldparam [Mixed]
    #
    def each_in_parallel(enumerable)
      threads = []

      enumerable.each do |value|
        threads << Thread.new { yield value }
      end

      threads.each(&:join)
    end
  end # ThreadingHelpers
end # Oga
