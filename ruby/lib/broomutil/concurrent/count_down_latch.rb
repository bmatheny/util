require 'thread'
require 'timeout'

require 'broomutil/mixins'
require 'broomutil/concurrent/good_time'

# Taken from https://github.com/benlangfeld/countdownlatch/blob/master/lib/countdownlatch.rb
module BroomUtil; module Concurrent

  class CountDownLatch

    def initialize count, name = nil
      BroomUtil::Mixins.require_type(count, Integer)
      BroomUtil::Mixins.require_that(count > 0, "count <= 0")
      @count = count.to_i
      @mutex = Mutex.new
      @name = name || "default"
      @conditional = ConditionVariable.new
      @logger = BroomUtil::Logging.get_logger self.class
      @logger.debug mk_log("Initializing with count #{count}")
    end

    def countdown!
      @logger.debug mk_log("countdown!")
      @mutex.synchronize do
        @count -= 1 if @count > 0
        @conditional.broadcast if @count == 0
      end
    end

    def count
      @mutex.synchronize { @count }
    end

    def to_s
      super.insert -2, " (Name = #{@name}, Count = #{@count})"
    end

    def wait timeout = nil, exception = false
      return true if count <= 0
      timeout = in_seconds timeout
      @logger.debug mk_log("Waiting for #{timeout} seconds")
      begin
        Timeout::timeout timeout do
          @mutex.synchronize do
            @conditional.wait @mutex if @count > 0
          end
        end
      rescue Timeout::Error => e
        if exception then
          raise e
        else
          return false
        end
      end
      true
    end

    protected
    def mk_log msg
      "Latch(name=#{@name}): #{msg}"
    end

    def in_seconds duration
      if duration.is_a?(BroomUtil::Concurrent::GoodTime) then
        duration.seconds
      else
        duration.to_i
      end
    end

  end
end; end
