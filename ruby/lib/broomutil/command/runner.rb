require 'broomutil/logging'
require 'broomutil/mixins'
require 'broomutil/command/result'

require 'io/wait'
require 'open3'

module BroomUtil
  module Command

    class Runner
      include ::BroomUtil::Mixins

      attr_accessor :test_results

      def initialize options = {}
        @test_results = options.fetch(:test_results, nil)
        @throws_on_error = options.fetch(:throws_on_error, true)
        @logger = BroomUtil::Logging.get_logger self.class
      end

      def run_nbio_stream command, io, spawn_options = {}
        return run_nbio(command, spawn_options) do |ch|
          io.write(ch)
        end
      end

      def run_nbio command, spawn_options = {}
        logger.debug "Executing command: #{command}"
        blk = nil
        if block_given? then
          blk = Proc.new
        end
        stdin, stdout_stderr, wait_thr = Open3.popen2e(command, spawn_options)
        stdin.close # don't need it
        results = []
        start = Time.now
        while wait_thr.alive? and not stdout_stderr.eof? do
          logger.trace "starting readline_nonblock"
          t1 = Time.now
          # we potentially sit here for a while before stderr is ready
          result = readline_nonblock(stdout_stderr, blk)
          results << result
          logger.trace "readline_nonblock took: #{Time.now - t1}"
        end
        stdout_stderr.close
        exit_status = wait_thr.value
        logger.debug "Executed command: #{command}, exit code #{exit_status.to_i.to_s}, total time taken: #{Time.now - start}"
        stderr = (exit_status == 0) ? "" : results.join
        stdout = (exit_status != 0) ? "" : results.join
        create_result command, stdout, stderr, exit_status
      end

      def run! command, spawn_options = {}
        unless test_results.nil? then
          logger.debug "test mode, would have run command: #{command}"
          return create_result(command, nil, nil, test_results)
        end
        logger.debug "running command: #{command}"
        begin
          Open3.popen3(command, spawn_options) { |stdin,stdout,stderr,thread|
            create_result command,
              stdout.read,
              stderr.read,
              thread.value
          }
        rescue Errno::ENOENT => e
          deets = {:error => e}
          BroomUtil::Command::Result.new stderr: e.message, command: command, details: deets
        rescue StandardError => e
          if @throws_on_error then
            throw e
          else
            deets = {:error => e}
            BroomUtil::Command::Result.new stderr: e.message, command: command, details: deets
          end
        end
      end

      private
      attr_accessor :logger
      def create_result cmd = nil, stdout = nil, stderr = nil, exit_code = -1
        if exit_code.class == Process::Status then
          exit_code = exit_code.exitstatus.to_i
        end
        BroomUtil::Command::Result.new exit_code: exit_code, stdout: stdout, stderr: stderr, command: cmd
      end

      # Do not use directly outside of readline_nonblock
      def readchar_nonblock io, &block
        begin
          done = false
          until done do
            ch = io.read_nonblock(1)
            done = block.call(ch)
          end
        rescue IO::WaitReadable
          logger.trace "got WaitReadable exception"
          t1 = Time.now
          IO.select([io], [io], [io])
          logger.trace "got event, waited #{Time.now - t1}"
          retry
        end
      end

      # Uses the non blocking API and returns a line at a time
      # You can optionally (additionally) provide a block for doing your own character handling
      def readline_nonblock io, optblock = nil
        buffer = ""
        readchar_nonblock io do |ch|
          buffer << ch
          if optblock then
            optblock.call(ch)
          end
          ch == "\n"
        end # readchar_nonblock
        return buffer
      end

    end # class Runner
  end # module Command
end # module BroomUtil
