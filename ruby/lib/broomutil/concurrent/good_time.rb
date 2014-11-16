require 'broomutil/concurrent/time_unit'

module BroomUtil; module Concurrent

  class GoodTime
    def initialize time, unit
      @time = time
      unless unit.is_a?(TimeUnit) then
        raise ExpectationFailedError.new("expected TimeUnit, got #{unit.class}")
      end
      @unit = unit
    end

    def millisecond
      @unit.millis(@time)
    end
    alias_method :milliseconds, :millisecond

    def second
      @unit.to_seconds(@time)
    end
    alias_method :seconds, :second

    def minute
      @unit.to_minutes(@time)
    end
    alias_method :minutes, :minute

    def hour
      @unit.to_hours(@time)
    end
    alias_method :hours, :hour

    def day
    end
    alias_method :days, :day

    def to_i
      seconds
    end

    def to_s
      "#{@time} #{@unit.to_s}"
    end
  end

end; end
