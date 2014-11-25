require 'logging'
require 'singleton'

# Usage:
# logger = BroomUtil::Logging.configure(self.class)
#   .level(:trace)
#   .trace(true)
#   .additive(false)
#   .appenders('broom.stdout.trace.on')
#   .logger()
# OR
# logger = BroomUtil::Logging.get_logger self.class
# Note that the above will inherit the root loggers configuration
module BroomUtil; module Logging

  COLOR_SCHEMES = {
    'broom.bright' => {
      :levels => {
        :warn   => :yellow,
        :error  => :red,
        :fatal  => [:white, :on_red]
      },
      :logger   => :cyan,
      :message  => :magenta
    },
  }

  PATTERNS = {
    'broom.stdout.trace.on'  => '%-5l [%d] %c.%M: %m\n',
    'broom.stdout.trace.off' => '%-5l [%d] %c: %m\n',
    'broom.date'      => '%Y-%m-%d %H:%M:%S.%L',
  }

  class <<self
    def configure name
      @_manager ||= LogManager.instance()
      FluentLogger.new(name)
    end

    def get_logger name
      @_manager ||= LogManager.instance()
      logger = ::Logging.logger[name]
      if ::Logging.logger.root.trace? then
        logger.trace = true
      end
      logger
    end

    def get_verbose increase, log_level
      sev = log_level
      if increase then
        if sev > ::Logging::LEVELS.values.min then
          sev -= 1
        end
      else
        if sev < ::Logging::LEVELS.values.max
          sev += 1
        end
      end
      sev
    end

    def level_name num
      ::Logging.levelify(::Logging::LNAMES[num])
    end

    def load_yaml file
      unless File.exists?(file) then
        raise BroomUtil::ExpectationFailedError.new("file #{file} does not exist")
      end
      @_manager ||= LogManager.instance()
      ::Logging.configure(file)
    end

    def load_ruby file
      unless File.exists?(file) then
        raise BroomUtil::ExpectationFailedError.new("file #{file} does not exist")
      end
      @_manager ||= LogManager.instance()
      begin
        load file
      rescue Exception => e
        raise BroomUtil::ExpectationFailedError.new("could not load config from file #{file}")
      end
    end
  end # class <<self

  class FluentLogger
    def initialize name
      @logger = ::BroomUtil::Logging.get_logger(name)
    end
    def from_config level, outfile
      if level.is_a?(Symbol) then
        lvl = level
      else
        lvl = BroomUtil::Logging.level_name(level)
      end
      level(lvl)
      if outfile.is_a?(String) then
        if @logger.trace? then
          pattern = PATTERNS['broom.stdout.trace.on']
        else
          pattern = PATTERNS['broom.stdout.trace.off']
        end
        ::Logging.appenders.file(
          outfile,
          :level => lvl,
          :layout => ::Logging.layouts.pattern(
            :pattern        => pattern,
            :date_pattern => PATTERNS['broom.date'],
          )
        )
        @logger.add_appenders(outfile)
      end
      self
    end
    def level l
      @logger.level = l
      self
    end
    def logger
      @logger
    end
    def trace t
      @logger.trace = t
      self
    end
    def additive a
      if @logger.respond_to?('additive') then
        @logger.additive = a
      end
      self
    end
    def appenders args
      @logger.appenders = args
      self
    end
  end

  class LogManager
    include Singleton

    def initialize
      unless ::Logging::LEVELS.key?(:trace) then
        ::Logging.reset
        ::Logging.init %w[trace debug info warn error fatal]
      end
      COLOR_SCHEMES.each do |k,v|
        ::Logging.color_scheme(k, v)
      end
      ::Logging.appenders.stdout(
        'broom.stdout.trace.off',
        :layout => ::Logging.layouts.pattern(
          :pattern      => PATTERNS['broom.stdout.trace.off'],
          :date_pattern => PATTERNS['broom.date'],
        ),
        :level => :debug
      )
      ::Logging.appenders.stdout(
        'broom.stdout.trace.on',
        :layout => ::Logging.layouts.pattern(
          :color_scheme => 'broom.bright',
          :pattern      => PATTERNS['broom.stdout.trace.on'],
          :date_pattern => PATTERNS['broom.date'],
        ),
        :level => :trace
      )
      r = ::Logging.logger.root
      r.level = :info
      r.trace = false
      r.appenders = 'broom.stdout.trace.off'
    end
  end

end; end
