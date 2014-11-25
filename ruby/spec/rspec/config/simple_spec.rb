require 'spec_helper'
require 'rspec/config_helper'

BUCS = BroomUtil::Config::Simple

context BroomUtil::Config::Simple do
  def get_simple_config
    BUCS.create do
      Option(:config, nil, ['-c', '--config=FILE', 'Configuration file to use'])
      Option(:time, 10, ['-t', '--time=TIME', Integer, 'Time int'])
    end
  end

  describe '.create' do
    it 'raises without a block' do
      expect {
        config = BUCS.create
      }.to raise_error(BroomUtil::ExpectationFailedError)
    end

    it 'creates a config with options' do
      sc = get_simple_config
      expect(sc.config).to have_key(:config)
      expect(sc.config[:config]).to be_nil
      expect(sc.config).to have_key(:time)
      expect(sc.config[:time]).to eq(10)
    end

    it 'accepts custom parsers' do
      parser_invoked = false
      outer = self
      sc = BUCS.create do
        Option :time, 10, ['-t', '--time=TIME', 'Time int'] do |cur,last|
          parser_invoked = true
          outer.expect(last).to outer.eq(10)
          outer.expect(cur).to outer.eq('15')
          cur.to_i
        end
      end # BUCS.create
      options = sc.parse! ['--time=15']
      expect(parser_invoked).to be true
      expect(options).to have_key(:time)
      expect(options[:time]).to eq(15)
    end

    it 'handles verbosity' do
      sc = BUCS.create do
        Option(:verbose, Logger::INFO, ['-v', '--[no-]verbose', 'Increase/Decrease verbosity'], :verbose)
      end
      options = sc.parse! ['-vvvvv']
      expect(options).to have_key(:verbose)
      expect(options[:verbose]).to eq(::Logging::LEVELS.values.min)

      options = sc.parse! ('--no-verbose '*5).strip.split
      expect(options).to have_key(:verbose)
      expect(options[:verbose]).to eq(::Logging::LEVELS.values.max)
    end
  end # describe '.create'

  describe '#parse!' do
    it 'parses short switches' do
      sc = get_simple_config
      options = sc.parse! ['-c', 'fizz', '-t', '20']
      expect(options).to have_key(:config)
      expect(options[:config]).to eq('fizz')
      expect(options).to have_key(:time)
      expect(options[:time]).to eq(20)
    end

    it 'parses long switches' do
      sc = get_simple_config
      options = sc.parse! ['--config=fuzz']
      expect(options).to have_key(:config)
      expect(options[:config]).to eq('fuzz')
      expect(options).to have_key(:time)
      expect(options[:time]).to eq(10)
    end

    it 'reuses defaults' do
      sc = get_simple_config
      options = sc.parse! ['--config=fizz', '--time=20']
      expect(options[:config]).to eq('fizz')
      expect(options[:time]).to eq(20)

      options = sc.parse! ['--config=fuzz']
      expect(options[:config]).to eq('fuzz')
      expect(options[:time]).to eq(10)
    end
  end # describe '#parse!'
end
