require 'spec_helper'
require 'rspec/command_helper'

context BroomUtil::Command::Runner do

  describe '#run!' do
    it 'respect tests_results' do
      cmd = "no such command"
      runner = BUCMD::Runner.new :test_results => 15
      result = runner.run! cmd
      expect(result).to be_an_instance_of(BroomUtil::Command::Result)
      expect(result.exit_code).to eq(15)
      expect(result.command).to eq(cmd)
    end

    it 'fails as expected' do
      cmd = "no such command"
      runner = BUCMD::Runner.new
      result = runner.run! cmd
      expect(result).to be_an_instance_of(BroomUtil::Command::Result)
      expect(result.exit_code).to be_nil
      expect(result.command).to eq(cmd)
      expect(result.stdout).to be_nil
      expect(result.details).to have_key(:error)
      expect(result.details[:error]).to be_an_instance_of(Errno::ENOENT)
    end

    it 'succeeds as expected' do
      cmd = 'ps aux'
      runner = BUCMD::Runner.new
      result = runner.run! cmd
      expect(result).to be_an_instance_of(BroomUtil::Command::Result)
      expect(result.exit_code).to eq(0)
      expect(result.success?).to be true
      expect(result.command).to eq(cmd)
      expect(result.stdout).to be_an_instance_of(String)
      expect(result.stdout.split("\n").size).to be > 2
    end
  end
end
