require 'logging'
require 'singleton'

# Usage:
# logger = BroomUtil::Logging.get_logger self.class
# BroomUtil::Logging.configure(self.class)
#   .level(:trace)
#   .trace(true)
#   .additive(false)
#   .appenders('broom.stdout.trace.on')
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
      ::Logging.logger[name]
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
    def level l
      @logger.level = l
      self
    end
    def trace t
      @logger.trace = t
      self
    end
    def additive a
      @logger.additive = a
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
