require 'ostruct'
require 'optparse'

require 'broomutil/logging'
require 'broomutil/mixins'

# Usage
# config = BroomUtil::Config::Simple.create do
#   Option(:logfile, STDOUT, ['-l', '--logfile=FILE', 'Log file to use'])
#   Option :start_time, '1 week ago', ['-s', '--start-time=TIME', "Start time, defaults to '%default'"] do |current,original|
#     Chronic.parse(current).to_i
#   end
#   Option(:verbose, Logger::INFO, ['-v', '--[no-]verbose', 'Increase (or decrease) verbosity'], :verbose)
# end
# options = config.parse! ARGV
module BroomUtil; module Config

  class Simple
    include BroomUtil::Mixins

    attr_accessor :config, :options

    def self.create &block
      require_that(block_given?, "Simple.create called without block")
      i = Simple.new
      i.instance_eval &block
      i
    end

    # If parser is a block/Proc it will receive two arguments when called for handling an argument,
    # the previous value of the option, and the new value of the option. It should return an
    # appropriately validated/formatted option.
    def Option key, default, args, parser = :identity
      @logger.trace "Option(key=#{key}, default=#{default.inspect}, args=#{args.inspect})"
      arg_parser = :identity
      if block_given? then
        arg_parser = Proc.new
      elsif parser.is_a?(Proc) then
        arg_parser = parser
      elsif parser == :verbose
        arg_parser = Proc.new {|current, orig| BroomUtil::Logging.get_verbose(current, orig)}
      elsif parser != :identity
        @logger.warn "Unknown parser specified for #{key}: type #{parser.class}, inspect '#{parser.inspect}'"
      end
      opt_args = args.map do |arg|
        if arg.is_a?(String) and arg.include?('%default') then
          arg.gsub('%default', default.to_s)
        else
          arg
        end
      end
      @options[key] = OpenStruct.new default: default, args: opt_args, parser: arg_parser
      @config[key] = default
    end

    def parse! argv
      parser().parse! argv
      @config
    end

    def parser banner = nil, width = 32, indent = (' ' * 4)
      OptionParser.new(banner, width, indent) do |opts|
        @options.each do |config_key,config_value|
          opt_default = config_value.default
          # NOTE this resets all config values to defaults which may be unexpected
          @config[config_key] = opt_default
          opt_args = config_value.args
          opt_parser = config_value.parser
          opts.on(*opt_args) do |arg_value|
            if opt_parser == :identity then
              @config[config_key] = arg_value
            else
              prev_value = @config[config_key]
              @config[config_key] = opt_parser.call(arg_value, prev_value)
            end
          end
        end
      end
    end

    def initialize
      @config = {}
      @options = {}
      @logger = ::BroomUtil::Logging.get_logger(self.class)
    end
  end

end; end
