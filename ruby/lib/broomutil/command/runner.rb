require 'broomutil/logger'
require 'broomutil/mixins'
require 'broomutil/command/result'

require 'open3'

module BroomUtil
  module Command

    class Runner
      include ::BroomUtil::Mixins

      attr_accessor :logger, :test_results

      def initialize config = {}
        @opts = create_config_hash config, downcase: true
        @logger = @opts.fetch(:logger, BroomUtil::Logger.get)
        @test_results = @opts[:test_results]
        @logger.debug "BroomUtil::Command::Runner opts => #{@opts}"
      end

      def run! command, spawn_options = {}
        unless test_results.nil? then
          logger.debug "test mode, would have run command: #{command}"
          return create_result(command, nil, nil, test_results)
        end
        logger.info "running command: #{command}"
        Open3.popen3(command, spawn_options) { |stdin,stdout,stderr,thread|
          create_result command,
            stdout.read,
            stderr.read,
            thread.value
        }
      end

      private
      def create_result cmd = nil, stdout = nil, stderr = nil, exit_code = -1
        if exit_code.class == Process::Status then
          exit_code = exit_code.exitstatus.to_i
        end
        BroomUtil::Command::Result.new exit_code: exit_code, stdout: stdout, stderr: stderr, command: cmd
      end

    end # class Runner
  end # module Command
end # module BroomUtil
