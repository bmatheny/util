# stolen from java.util.concurrent
module BroomUtil; module Concurrent
  class TimeUnit

    # FIXME - finish to_nanos, to_micros all around and tests
    module Details
      # Constants for conversions
      C0            = 1
      C1            = C0*1000
      C2            = C1*1000
      C3            = C2*1000
      C4            = C3*60
      C5            = C4*60
      C6            = C5*24
      MAX           = 9223372036854775807
      MIN           = -9223372036854775808
    end

    # Usage:
    # TimeUnit::SECONDS.convert(100, TimeUnit::MILLISECONDS) -> 0.10
    # TimeUnit::MILLISECONDS.convert(0.10, TimeUnit::SECONDS) -> 100
    # TimeUnit::SECONDS.to_millis(0.10) -> 100
    # TimeUnit::MILLISECONDS.to_seconds(100) -> 0.10
    # Available units are: NANOSECONDS, MICROSECONDS, MILLISECONDS, SECONDS,
    # MINUTES, HOURS, DAYS

    # Convert the given time duration in the given unit to this unit
    def convert sourceDuration, sourceUnit
      raise NotImplementedError.new("convert not implemented")
    end

    def to_nanos d
      raise NotImplementedError.new("to_nanos not implemented")
    end
    alias_method :to_nanoseconds, :to_nanos
    def to_micros d
      raise NotImplementedError.new("to_micros not implemented")
    end
    alias_method :to_microseconds, :to_micros
    def to_millis d
      raise NotImplementedError.new("to_millis not implemented")
    end
    alias_method :to_milliseconds, :to_millis
    def to_seconds d
      raise NotImplementedError.new("to_seconds not implemented")
    end
    def to_minutes d
      raise NotImplementedError.new("to_minutes not implemented")
    end
    def to_hours d
      raise NotImplementedError.new("to_hours not implemented")
    end
    def to_days d
      raise NotImplementedError.new("to_days not implemented")
    end

    def nanoseconds?; false; end
    def microseconds?; false; end
    def milliseconds?; false; end
    def seconds?; false; end
    def minutes?; false; end
    def hours?; false; end
    def days?; false; end

    def to_s
      raise NotImplementedError.new("to_s not implemented")
    end

    private
    def x d, m, over
      return Details::MAX if d > over
      return Details::MIN if d < -over
      d * m
    end

    public
    NANOSECONDS = new
    class <<NANOSECONDS
      def to_s; "nanoseconds"; end
      def nanoseconds?; true; end
      def to_nanos(d); d; end
      def to_micros(d); d.to_f/(Details::C1/Details::C0); end
      def to_millis(d); d.to_f/(Details::C2/Details::C0); end
      def to_seconds(d); d.to_f/(Details::C3/Details::C0); end
      def to_minutes(d); d.to_f/(Details::C4/Details::C0); end
      def to_hours(d); d.to_f/(Details::C5/Details::C0); end
      def to_days(d); d.to_f/(Details::C6/Details::C0); end
      def convert(d, u); u.to_nanos(d); end
    end

    MICROSECONDS = new
    class <<MICROSECONDS
      def to_s; "microseconds"; end
      def microseconds?; true; end
      def to_nanos d
        m = Details::C1.to_f / Details::C0
        x d, m, Details::MAX/m
      end
      def to_micros(d);   d; end
      def to_millis(d);   d.to_f/(Details::C2/Details::C1); end
      def to_seconds(d);  d.to_f/(Details::C3/Details::C1); end
      def to_minutes(d);  d.to_f/(Details::C4/Details::C1); end
      def to_hours(d);    d.to_f/(Details::C5/Details::C1); end
      def to_days(d);     d.to_f/(Details::C6/Details::C1); end
      def convert(d, u);  u.to_micros(d); end
    end

    MILLISECONDS = new
    class <<MILLISECONDS
      def to_s; "milliseconds"; end
      def milliseconds?; true; end
      def to_millis(d); d; end
      def to_seconds(d); d.to_f/(Details::C3/Details::C2); end
      def to_minutes(d); d.to_f/(Details::C4/Details::C2); end
      def to_hours(d); d.to_f/(Details::C5/Details::C2); end
      def to_days(d); d.to_f/(Details::C6/Details::C2); end
      def convert(d, u); u.to_millis(d); end
    end

    SECONDS = new
    class <<SECONDS
      def to_s; "seconds"; end
      def seconds?; true; end
      def to_millis d
        m = Details::C3.to_f/Details::C2
        x d, m, Details::MAX/m
      end
      def to_seconds(d); d; end
      def to_minutes(d); d.to_f/(Details::C4/Details::C3); end
      def to_hours(d); d.to_f/(Details::C5/Details::C3); end
      def to_days(d); d.to_f/(Details::C6/Details::C3); end
      def convert(d, u); u.to_seconds(d); end
    end

    MINUTES = new
    class <<MINUTES
      def to_s; "minutes"; end
      def minutes?; true; end
      def to_millis d
        m = Details::C4.to_f / Details::C2
        x d, m, Details::MAX.to_f/m
      end
      def to_seconds(d)
        m = Details::C4.to_f / Details::C3
        x d, m, Details::MAX.to_f / m
      end
      def to_minutes(d); d; end
      def to_hours(d); d.to_f/(Details::C5/Details::C4); end
      def to_days(d); d.to_f/(Details::C6/Details::C4); end
      def convert(d, u); u.to_minutes(d); end
    end

    HOURS = new
    class <<HOURS
      def to_s; "hours"; end
      def hours?; true; end
      def to_millis d
        m = Details::C5.to_f / Details::C2
        x d, m, Details::MAX.to_f/m
      end
      def to_seconds(d)
        m = Details::C5.to_f / Details::C3
        x d, m, Details::MAX.to_f / m
      end
      def to_minutes(d)
        m = Details::C5.to_f / Details::C4
        x d, m, Details::MAX.to_f / m
      end
      def to_hours(d); d; end
      def to_days(d); d.to_f/(Details::C6/Details::C5); end
      def convert(d, u); u.to_hours(d); end
    end

    DAYS = new
    class <<DAYS
      def to_s; "days"; end
      def days?; true; end
      def to_millis d
        m = Details::C6.to_f / Details::C2
        x d, m, Details::MAX.to_f/m
      end
      def to_seconds(d)
        m = Details::C6.to_f / Details::C3
        x d, m, Details::MAX.to_f / m
      end
      def to_minutes(d)
        m = Details::C6.to_f / Details::C4
        x d, m, Details::MAX.to_f / m
      end
      def to_hours(d)
        m = Details::C6.to_f / Details::C5
        x d, m, Details::MAX.to_f / m
      end
      def to_days(d); d; end
      def convert(d, u); u.to_days(d); end
    end

    private_class_method :new

  end # class TimeUnit

end; end
