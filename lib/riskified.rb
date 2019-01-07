require "riskified/version"
require 'riskified/configuration'
require 'riskified/client'

module Riskified
  class << self
    attr_accessor :configuration
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
