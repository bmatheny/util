require 'spec_helper'
require 'rspec/concurrent_helper'

context BroomUtil::Concurrent::TimeUnit do

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
