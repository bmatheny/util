require 'logger'
require 'pp'

unless $:.include?(File.dirname(__FILE__)) then
  $:.unshift File.dirname(__FILE__)
end

module BroomUtil
  def self.monkeypatch?
    defined?($BROOM_UTIL_MONKEYPATCH) and $BROOM_UTIL_MONKEYPATCH
  end
end

require 'broomutil/errors'
require 'broomutil/logger'
require 'broomutil/mixins'
require 'broomutil/project'
