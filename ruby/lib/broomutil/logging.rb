require 'logging'

module BroomUtil; module Logging
  class <<self
    def get_logger name
      ::Logging.logger[name]
    end
  end
end; end
