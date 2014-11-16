require 'spec_helper'
require 'rspec/concurrent_helper'

describe BroomUtil::Concurrent::GoodTime do

  it 'basics' do
    expect(1.day.hours).to eq(24)
    expect(24.hours.day).to eq(1)

    expect(1.hour.minutes).to eq(60)
    expect(60.minutes.hours).to eq(1)

    expect(1.minute.seconds).to eq(60)
    expect(60.seconds.minutes).to eq(1)

    expect(1.second.milliseconds).to eq(1000)
    expect(1000.milliseconds.seconds).to eq(1)

    expect(1.millisecond.microseconds).to eq(1000)
    expect(1000.microseconds.milliseconds).to eq(1)

    expect(1.microsecond.nanoseconds).to eq(1000)
    expect(1000.nanoseconds.microseconds).to eq(1)
  end

  it '1.day.seconds == 86400' do
    expect(1.day.seconds).to eq(86400)
  end

  it '120.minutes.hours == 2' do
    expect(120.minutes.hours).to eq(2)
  end

end
