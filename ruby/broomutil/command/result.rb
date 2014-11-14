require 'broomutil/mixins'

module BroomUtil
  module Command
    class Result
      include ::BroomUtil::Mixins

      attr_accessor :exit_code, :command, :details, :stdout, :stderr, :success

      def self.error details = {}
        Result.new :exit_code => -1, :details => details
      end

      def initialize options = {}
        hash = symbolize_hash options, :downcase => true
        if hash.key?(:exit_code) then
          @exit_code = hash[:exit_code].to_i
        else
          @exit_code = nil
        end
        @command = hash[:command]
        @details = hash[:details]
        @stdout = hash[:stdout]
        @stderr = hash[:stderr]
        @success = hash.fetch(:success, @exit_code == 0)
      end

      def success?
        @success
      end

      def to_hash
        {
          :exit_code => exit_code,
          :command => command,
          :details => details,
          :stdout => stdout,
          :stderr => stderr,
          :success => success
        }
      end

      def to_s
        "BroomUtil::Command::Result(exit_code='#{exit_code}', command='#{command}', success='#{success}', details='#{details}', stdout='#{stdout}', stderr='#{stderr}')"
      end
    end
  end
end
