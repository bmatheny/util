require 'thread'

module BroomUtil
  module Concurrent

    class ThreadPool
      attr_reader :size

      def initialize size = 24
        @size  = size
        @queue = Queue.new
        @pool  = queue_processor
      end

      def queue_size
        queue.size
      end

      def status
        "queue size #{queue_size}, #{size} threads, #{queue.num_waiting} waiting"
      end

      def submit *args, &block
        queue.enq [block, args]
      end

      def shutdown timeout = nil
        result = true
        size.times do
          submit { throw :exit }
        end
        if timeout then
          begin
            Timeout::timeout timeout.to_i do
              pool.map(&:join)
            end
          rescue Timeout::Error => e
            pool.each {|t| t.kill}
            result = false
          end
        else
          pool.map(&:join)
        end
        queue.clear
        pool = queue_processor
        result
      end

      protected
      attr_reader :pool, :queue
      def queue_processor
        Array.new(size) do |i|
          Thread.new do
            Thread.current[:id] = i
            catch(:exit) do
              loop do
                job, args = queue.deq
                job.call(*args)
              end
            end
          end
        end
      end
    end

  end # module Concurrent

end # module BroomUtil
