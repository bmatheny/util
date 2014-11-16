require 'broomutil/concurrent/time_unit'

module BroomUtil; module Concurrent

  class GoodTime
    def initialize time, unit
      @time = time
      @unit = TimeUnit.new unit
    end

    def millisecond
      case
      when @unit.milliseconds?
        @time
      when @unit.seconds?
        @time * 1000
      when @unit.minutes?
        @time * 1000 * 60
      when @unit.hours?
        @time * 1000 * 60 * 60
      when @unit.days?
        @time * 1000 * 60 * 60 * 24
      end
    end

    def milliseconds
      millisecond
    end

    def second
      milliseconds / 1000
    end

    def seconds
      second
    end

    def minutes
      seconds / 60
    end

    def hour
      minutes / 60
    end

    def hours
      minutes / 60
    end

    def to_i
      seconds
    end

    def to_s
      "#{@time} #{@unit.to_s}"
    end
  end

end; end
