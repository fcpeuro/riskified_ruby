require "riskified/version"
require 'riskified/configuration'
require 'riskified/client'
require 'riskified/Entities/address'
require 'riskified/Entities/client_details'
require 'riskified/Entities/customer'
require 'riskified/Entities/discount_code'
require 'riskified/Entities/line_item'
require 'riskified/Entities/order'
require 'riskified/Entities/shipping_line'
require 'riskified/Exceptions/api_connection_error'
require 'riskified/Exceptions/unexpected_order_status'
require 'riskified/Statuses/approved'
require 'riskified/Statuses/declined'

module Riskified
  class << self
    attr_accessor :configuration
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.validate_configuration
    @configuration.validate
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(config)
  end
end
