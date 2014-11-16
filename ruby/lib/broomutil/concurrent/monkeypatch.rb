# Convert fixnum to GoodTime unit
class Fixnum
  def millisecond
    BroomUtil::Concurrent::GoodTime.new(self, BroomUtil::Concurrent::TimeUnit::MILLISECONDS)
  end
  alias_method :milliseconds, :millisecond

  def second
    BroomUtil::Concurrent::GoodTime.new(self, BroomUtil::Concurrent::TimeUnit::SECONDS)
  end
  alias_method :seconds, :second

  def minute
    BroomUtil::Concurrent::GoodTime.new(self, BroomUtil::Concurrent::TimeUnit::MINUTES)
  end
  alias_method :minutes, :minute

  def hour
    BroomUtil::Concurrent::GoodTime.new(self, BroomUtil::Concurrent::TimeUnit::HOURS)
  end
  alias_method :hours, :hour

  def day
    BroomUtil::Concurrent::GoodTime.new(self, BroomUtil::Concurrent::TimeUnit::DAYS)
  end
  alias_method :days, :day
end
