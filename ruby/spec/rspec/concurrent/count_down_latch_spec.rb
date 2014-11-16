require 'spec_helper'
require 'rspec/concurrent_helper'

context BroomUtil::Concurrent::CountDownLatch do

  describe '#initialize' do
    it 'has a default name' do
      cdl = BUC::CountDownLatch.new 2
      expect(cdl.to_s).to match /Name = default/
    end

    it 'uses a specified name' do
      cdl = BUC::CountDownLatch.new 2, 'rspec'
      expect(cdl.to_s).to match /Name = rspec/
    end
  end

  describe '#countdown!' do
    subject(:cdl) { BUC::CountDownLatch.new(2) }

    it 'decrements to 0' do
      [2, 1, 0, 0].each do |i|
        expect(cdl.count).to eq(i)
        cdl.countdown!
      end
    end
  end

  describe '#wait' do
    subject(:cdl) { BUC::CountDownLatch.new(2) }

    it 'returns true when successful' do
      cdl.countdown!
      cdl.countdown!
      expect(cdl.wait(1.second)).to be true
    end

    it 'returns false on timeout' do
      cdl.countdown!
      expect(cdl.count).to eq(1)
      expect(cdl.wait(1.second)).to be false
    end

    it 'raises on timeout if specified' do
      cdl.countdown!
      expect{cdl.wait(1.second, true)}.to raise_error(Timeout::Error)
    end
  end

end
