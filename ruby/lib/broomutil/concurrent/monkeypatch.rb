# Convert fixnum to GoodTime unit
class Fixnum
  def nanosecond
    make_good_time self, :NANOSECONDS
  end
  alias_method :nanoseconds, :nanosecond

  def microsecond
    make_good_time self, :MICROSECONDS
  end
  alias_method :microseconds, :microsecond

  def millisecond
    make_good_time self, :MILLISECONDS
  end
  alias_method :milliseconds, :millisecond

  def second
    make_good_time self, :SECONDS
  end
  alias_method :seconds, :second

  def minute
    make_good_time self, :MINUTES
  end
  alias_method :minutes, :minute

  def hour
    make_good_time self, :HOURS
  end
  alias_method :hours, :hour

  def day
    make_good_time self, :DAYS
  end
  alias_method :days, :day

  private
  def make_good_time i, u
    unit = BroomUtil::Concurrent::TimeUnit.const_get u
    BroomUtil::Concurrent::GoodTime.new(i, unit)
  end
end
