require 'thread'
require 'timeout'

require 'broomutil/concurrent/good_time'

# Taken from https://github.com/benlangfeld/countdownlatch/blob/master/lib/countdownlatch.rb
module BroomUtil; module Concurrent

  class CountDownLatch

    def initialize count, name, logger = nil
      @count = count
      @mutex = Mutex.new
      @name = name
      @conditional = ConditionVariable.new
      @logger = logger || BroomUtil::Logger.get
      log "Initializing with count #{count}"
    end

    def countdown!
      @mutex.synchronize do
        log "countdown!"
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
      return if count <= 0
      timeout = in_seconds timeout
      log "Waiting for #{timeout} seconds"
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
          false
        end
      end
    end

    protected
    def log msg
      @logger.debug "Concurrent::CountDownLatch(#{@name}): #{msg}"
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
