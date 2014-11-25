require 'spec_helper'

BUM = BroomUtil::Mixins
context BroomUtil::Mixins do

  describe '.require_type' do
    it 'raises when type is invalid' do
      expect {
        BUM.require_type('string', Integer)
      }.to raise_error(ArgumentError)
    end
    it 'does not raise when valid' do
      expect(BUM.require_type(10, Integer)).to be_nil
    end
  end
end
