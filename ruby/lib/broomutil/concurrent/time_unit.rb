# stolen from java.util.concurrent
module BroomUtil; module Concurrent
  class TimeUnit

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

    def timed_join thread, timeout
      return unless timeout > 0
      thread.join(to_seconds(timeout))
    end

    def sleep timeout
      return unless timeout > 0
      sleep(to_seconds(timeout))
    end

    # Convert the given time duration in the given unit to this unit
    def convert duration, unit
      raise NotImplementedError.new("convert not implemented")
    end

    def x_nanos d, m
      raise NotImplementedError.new("x_nanos not implemented")
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
    alias_method :nanos?, :nanoseconds?
    def microseconds?; false; end
    alias_method :micros?, :microseconds?
    def milliseconds?; false; end
    alias_method :millis?, :milliseconds?
    def seconds?; false; end
    def minutes?; false; end
    def hours?; false; end
    def days?; false; end

    def to_s
      raise NotImplementedError.new("to_s not implemented")
    end

    private
    # convert a smaller unit to a larger unit (d will get smaller)
    def xd d, num, den
      numerator = Details.const_get num
      denominator = Details.const_get den
      d.to_f / (numerator / denominator)
    end
    # convert a larger unit to a smaller unit (d will get larger)
    def xm d, num, den
      numerator = Details.const_get num
      denominator = Details.const_get den
      m = numerator.to_f / denominator
      over = Details::MAX.to_f / m

      return Details::MAX if d > over
      return Details::MIN if d < -over
      d * m
    end
    def xc d, m, m1
      multiplier1 = Details.const_get m1
      ((d*multiplier1) - (m*Details::C2)).to_i
    end

    public
    NANOSECONDS = new
    class <<NANOSECONDS
      def to_s;           "nanoseconds"; end
      def nanoseconds?;   true; end
      def to_nanos(d);    d; end
      def to_micros(d);   xd(d, :C1, :C0); end
      def to_millis(d);   xd(d, :C2, :C0); end
      def to_seconds(d);  xd(d, :C3, :C0); end
      def to_minutes(d);  xd(d, :C4, :C0); end
      def to_hours(d);    xd(d, :C5, :C0); end
      def to_days(d);     xd(d, :C6, :C0); end
      def convert(d, u);  u.to_nanos(d); end
      def x_nanos(d, m);  xc(d, m, :C0); end
    end

    MICROSECONDS = new
    class <<MICROSECONDS
      def to_s;           "microseconds"; end
      def microseconds?;  true; end
      def to_nanos(d);    xm(d, :C1, :C0); end
      def to_micros(d);   d; end
      def to_millis(d);   xd(d, :C2, :C1); end
      def to_seconds(d);  xd(d, :C3, :C1); end
      def to_minutes(d);  xd(d, :C4, :C1); end
      def to_hours(d);    xd(d, :C5, :C1); end
      def to_days(d);     xd(d, :C6, :C1); end
      def convert(d, u);  u.to_micros(d); end
      def x_nanos(d, m);  xc(d, m, :C1); end
    end

    MILLISECONDS = new
    class <<MILLISECONDS
      def to_s;           "milliseconds"; end
      def milliseconds?;  true; end
      def to_nanos(d);    xm(d, :C2, :C0); end
      def to_micros(d);   xm(d, :C2, :C1); end
      def to_millis(d);   d; end
      def to_seconds(d);  xd(d, :C3, :C2); end
      def to_minutes(d);  xd(d, :C4, :C2); end
      def to_hours(d);    xd(d, :C5, :C2); end
      def to_days(d);     xd(d, :C6, :C2); end
      def convert(d, u);  u.to_millis(d); end
      def x_nanos(d, u);  0; end
    end

    SECONDS = new
    class <<SECONDS
      def to_s;           "seconds"; end
      def seconds?;       true; end
      def to_nanos(d);    xm(d, :C3, :C0); end
      def to_micros(d);   xm(d, :C3, :C1); end
      def to_millis(d);   xm(d, :C3, :C2); end
      def to_seconds(d);  d; end
      def to_minutes(d);  xd(d, :C4, :C3); end
      def to_hours(d);    xd(d, :C5, :C3); end
      def to_days(d);     xd(d, :C6, :C3); end
      def convert(d, u);  u.to_seconds(d); end
      def x_nanos(d, u);  0; end
    end

    MINUTES = new
    class <<MINUTES
      def to_s;           "minutes"; end
      def minutes?;       true; end
      def to_nanos(d);    xm(d, :C4, :C0); end
      def to_micros(d);   xm(d, :C4, :C1); end
      def to_millis(d);   xm(d, :C4, :C2); end
      def to_seconds(d);  xm(d, :C4, :C3); end
      def to_minutes(d);  d; end
      def to_hours(d);    xd(d, :C5, :C4); end
      def to_days(d);     xd(d, :C6, :C4); end
      def convert(d, u);  u.to_minutes(d); end
      def x_nanos(d, u);  0; end
    end

    HOURS = new
    class <<HOURS
      def to_s;           "hours"; end
      def hours?;         true; end
      def to_nanos(d);    xm(d, :C5, :C0); end
      def to_micros(d);   xm(d, :C5, :C1); end
      def to_millis(d);   xm(d, :C5, :C2); end
      def to_seconds(d);  xm(d, :C5, :C3); end
      def to_minutes(d);  xm(d, :C5, :C4); end
      def to_hours(d);    d; end
      def to_days(d);     xd(d, :C6, :C5); end
      def convert(d, u);  u.to_hours(d); end
      def x_nanos(d, u);  0; end
    end

    DAYS = new
    class <<DAYS
      def to_s;           "days"; end
      def days?;          true; end
      def to_nanos(d);    xm(d, :C6, :C0); end
      def to_micros(d);   xm(d, :C6, :C1); end
      def to_millis(d);   xm(d, :C6, :C2); end
      def to_seconds(d);  xm(d, :C6, :C3); end
      def to_minutes(d);  xm(d, :C6, :C4); end
      def to_hours(d);    xm(d, :C6, :C5); end
      def to_days(d);     d; end
      def convert(d, u);  u.to_days(d); end
      def x_nanos(d, u);  0; end
    end

    def self.values
      [NANOSECONDS, MICROSECONDS, MILLISECONDS, SECONDS, MINUTES, HOURS, DAYS]
    end

    private_class_method :new

  end # class TimeUnit

end; end
