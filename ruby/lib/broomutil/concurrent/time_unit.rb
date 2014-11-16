# stolen from java.util.concurrent
module BroomUtil; module Concurrent
  class TimeUnit
    MILLISECONDS  = 0
    SECONDS       = 1
    MINUTES       = 2
    HOURS         = 3
    DAYS          = 4

    def initialize unit
      @unit = unit
    end

    def milliseconds?
      @unit == MILLISECONDS
    end

    def seconds?
      @unit == SECONDS
    end

    def minutes?
      @unit == MINUTES
    end

    def hours?
      @unit == HOURS
    end

    def days?
      @unit == DAYS
    end

    def to_s
      case @unit
      when MILLISECONDS
        "milliseconds"
      when SECONDS
        "seconds"
      when MINUTES
        "minutes"
      when HOURS
        "hours"
      when DAYS
        "days"
      end
    end
  end

end; end
