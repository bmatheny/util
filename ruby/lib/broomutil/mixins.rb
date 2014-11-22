require 'broomutil/errors'

module BroomUtil
  module Mixins

    def self.included base
      base.extend(BroomUtil::Mixins)
    end

    def create_config_hash hash, options = {}
      if hash.key?(:logger) then
        logger = hash.delete(:logger)
        results = symbolize_hash(deep_copy_hash(hash), options)
        results[:logger] = logger
        hash[:logger] = logger
        results
      else
        symbolize_hash(deep_copy_hash(hash), options)
      end
    end

    # Create a deep copy of a hash
    #
    # This is useful for copying a hash that will be mutated
    # @note All keys and values must be serializable, Proc for instance will fail
    # @param [Hash] hash the hash to copy
    # @return [Hash]
    def deep_copy_hash hash
      require_that(hash.is_a?(Hash), "deep_copy_hash requires a hash be specified, got #{hash.class}")
      Marshal.load Marshal.dump(hash)
    end

    # Raise a NotImplementedError
    #
    # @param [String|Symbol] name the name of the method not implemented
    # @raise [NotImplementedError] always raises
    def raise_not_implemented name
      raise NotImplementedError.new("#{name.to_s} not implemented")
    end

    # Require that a guard condition passes
    #
    # Simply checks that the guard is truthy, and throws an error otherwise
    def require_that guard, message, alt_result = nil #return_guard = false
      unless guard then
        raise ExpectationFailedError.new(message)
      end
      if alt_result.nil? then
        guard
      else
        alt_result
      end
    end

    # Given a hash, rewrite keys to symbols
    #
    # @param [Hash] hash the hash to symbolize
    # @param [Hash] options specify how to process the hash
    # @option options [Boolean] :rewrite_regex if the value is a regex and this is true, convert it to a string
    # @option options [Boolean] :downcase if true, downcase the keys as well
    # @raise [ExpectationFailedError] if hash is not a hash
    def symbolize_hash hash, options = {}
      return {} if (hash.nil? or hash.empty?)
      (raise ExpectationFailedError.new("symbolize_hash called without a hash")) unless hash.is_a?(Hash)
      hash.inject({}) do |result, (k,v)|
        key = options[:downcase] ? k.to_s.downcase.to_sym : k.to_s.to_sym
        if v.is_a?(Hash) then
          result[key] = symbolize_hash(v)
        elsif v.is_a?(Regexp) && options[:rewrite_regex] then
          result[key] = v.inspect[1..-2]
        else
          result[key] = v
        end
        result
      end
    end

    # This provides access to these methods as BroomUtil::Mixins.method_name
    [:deep_copy_hash, :require_that, :symbolize_hash].each do |method|
      module_function method
      public method # without this, module_function makes the method private
    end

  end
end
