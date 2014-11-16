require 'spec_helper'
require 'rspec/concurrent_helper'

describe BroomUtil::Concurrent::GoodTime do

  it '1.day.seconds == 86400' do
    expect(1.day.seconds).to eq(86400)
  end

  it '120.minutes.hours == 2' do
    expect(120.minutes.hours).to eq(2)
  end

end
