require 'spec_helper'
require 'rspec/concurrent_helper'

BUTU = BroomUtil::Concurrent::TimeUnit
context BroomUtil::Concurrent::TimeUnit do

  describe 'invariants' do
    it 'is a TimeUnit' do
      BUC::TimeUnit.values.each do |u|
        expect(u).to be_instance_of(BUC::TimeUnit)
      end
    end

    it 'identity property holds' do |u|
      BUC::TimeUnit.values.each do |u|
        expect(u.convert(42, u)).to eq(42)
        BUC::TimeUnit.values.each do |v|
          if u.convert(42, v) >= 42 then
            expect(v.convert(u.convert(42, v), u)).to eq(42)
          end
        end # inner loop
      end # outer loop
    end # identify
  end # describe

  describe 'conversions' do
    it '#convert' do
      expect(BUTU::HOURS.convert(       1, BUTU::DAYS)        ).to eq(24)
      expect(BUTU::MINUTES.convert(     1, BUTU::HOURS)       ).to eq(60)
      expect(BUTU::SECONDS.convert(     1, BUTU::MINUTES)     ).to eq(60)
      expect(BUTU::MILLISECONDS.convert(1, BUTU::SECONDS)     ).to eq(1000)
      expect(BUTU::MICROSECONDS.convert(1, BUTU::MILLISECONDS)).to eq(1000)
      expect(BUTU::NANOSECONDS.convert( 1, BUTU::MICROSECONDS)).to eq(1000)
    end
    
    it '#to_*' do
        expect(BUTU::DAYS.to_hours(1)         ).to eq(24)
        expect(BUTU::HOURS.to_minutes(1)      ).to eq(60)
        expect(BUTU::MINUTES.to_seconds(1)    ).to eq(60)
        expect(BUTU::SECONDS.to_millis(1)     ).to eq(1000)
        expect(BUTU::MILLISECONDS.to_micros(1)).to eq(1000)
        expect(BUTU::MICROSECONDS.to_nanos(1) ).to eq(1000)
    end
  end

  describe '#initialize' do
    it 'is private' do
      expect {
        BUC::TimeUnit.new(-1, "thing")
      }.to raise_error(NoMethodError)
    end
  end

  describe 'MILLISECONDS' do
    subject(:tu) { BUC::TimeUnit::MILLISECONDS }

    it '#milliseconds? == true' do
      expect(tu.milliseconds?).to be true
    end

    it '#seconds? == false' do
      expect(tu.seconds?).to be false
    end

    it '#to_seconds' do
      # convert 100ms to seconds
      sim = tu.to_seconds(100)
      expect(sim).to eq(0.10)

      # convert 10000ms to seconds
      sim = tu.to_seconds(10000)
      expect(sim).to eq(10)
    end

    it '#convert' do
      # convert 0.10 seconds to milliseconds
      sim = tu.convert(0.10, BUC::TimeUnit::SECONDS)
      expect(sim).to eq(100)

      # convert 10 seconds to milliseconds
      sim = tu.convert(10, BUC::TimeUnit::SECONDS)
      expect(sim).to eq(10000)
    end

    it '#to_s' do
      expect(tu.to_s).to eq('milliseconds')
    end
  end

  describe 'SECONDS' do
    subject(:tu) { BUC::TimeUnit::SECONDS }

    it '#seconds? == true' do
      expect(tu.seconds?).to be true
    end

    it '#convert' do
      # convert 100ms to seconds
      sim = tu.convert(100, BUC::TimeUnit::MILLISECONDS)
      expect(sim).to eq(0.10)

      # convert 10000ms to seconds
      sim = tu.convert(10000, BUC::TimeUnit::MILLISECONDS)
      expect(sim).to eq(10)
    end

    it '#to_millis' do
      # convert 0.10 seconds to milliseconds
      sim = tu.to_millis(0.10)
      expect(sim).to eq(100)

      # convert 10 seconds to milliseconds
      sim = tu.to_millis(10)
      expect(sim).to eq(10000)
    end

    it '#to_s' do
      expect(tu.to_s).to eq('seconds')
    end
  end

end
