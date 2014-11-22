# Usage
# BroomUtil::Project.new('pname', File.dirname(__FILE__))
#   .with_broom_module('git')
#   .with_project_modules('mod1')
#   .load_project()
# This will try to load the following files
#   UTIL_BASE/broomutil/pname
#   UTIL_BASE/broomutil/pname.rb
#   UTIL_BASE/broomutil/pname/*.rb
#   UTIL_BASE/broomutil/git
#   PROJECT_BASE/lib/mod1
#   PROJECT_BASE/lib/mod1.rb
#   PROJECT_BASE/lib/mod1/*.rb
#   PROJECT_BASE/lib/pname
#   PROJECT_BASE/lib/pname.rb
#   PROJECT_BASE/lib/pname/*
module BroomUtil

  class Project

    attr_accessor :logger
    attr_reader :project, :project_base, :util_base

    def initialize project_name, project_base
      this_dir = File.dirname(__FILE__)
      @project = project_name
      @project_base = File.join(project_base, 'lib')
      @util_base = this_dir

      unless $:.include?(this_dir) then
        $:.unshift this_dir
      end

      unless $:.include?(@project_base) then
        $:.unshift @project_base
      end

      @logger = BroomUtil::Logging.get_logger self.class

      # Require UTIL_BASE/project*
      require_module @util_base, project_name, false
    end # def init

    def self.init_project project_name, project_base, logger = nil
      BroomUtil.new(project_name, project_base, logger)
    end

    def load_project
      require_module @project_base, @project, false
      self
    end
    def with_project_module module_name
      with_project_modules module_name
      self
    end
    def with_project_modules module_name, *more_modules
      require_module @project_base, module_name
      more_modules.each do |name|
        require_module @project_base, name
      end
      self
    end

    def with_broom_module module_name
      with_broom_modules module_name
      self
    end

    def with_broom_modules module_name, *more_modules
      require File.join(@util_base, module_name)
      more_modules.each do |name|
        require File.join(@util_base, name)
      end
      self
    end

    protected
    def require_files path
      Dir[File.join(path, '/*.rb')].each do |file|
        logger.debug "require(#{file})"
        require file
      end
    end

    def require_module module_base, module_name, should_exist = true
      module_path = File.join(module_base, module_name)
      alt_path = "#{module_path}.rb"
      if File.file?(module_path) then
        logger.debug "require(#{module_path})"
        require module_path
      elsif File.file?(alt_path) then
        logger.debug "require(#{alt_path})"
        require alt_path
      elsif File.directory?(module_path) then
        logger.debug "require_files(#{module_path})"
        require_files module_path
      elsif should_exist
        logger.warn "Neither #{module_path} or #{alt_path} exist as a file or directory"
      end
    end

  end # class Project
end # module BroomUtil
