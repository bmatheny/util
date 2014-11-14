require 'logger'
require 'singleton'

module BroomUtil

  class Logger
    include Singleton
    attr_accessor :logger

    def self.get
      ::BroomUtil::Logger.instance().logger
    end

    def self.set logger
      i = ::BroomUtil::Logger.instance()
      i.logger = logger
      i
    end

    def initialize
      @logger = ::Logger.new(STDERR)
      @logger.level = ::Logger::WARN
    end
  end

end
