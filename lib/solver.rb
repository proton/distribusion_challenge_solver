lib_dir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift(lib_dir) unless $:.include?(lib_dir)

require 'unirest'
require 'zip'
require 'csv'

require 'password_loader'
require 'sentinels_processor'

module DistributionChallenge
  class Solver
    include Service

    SOURCES = %w(sentinels sniffers loopholes)

    attr_reader :password

    def call
      get_password
      exit_from_matrix
    end

    private

    def get_password
      @password = PasswordLoader.call
    end

    def exit_from_matrix
      p SentinelsProcessor.call(password)
      # p SniffersProcessor.call
      # p LoopholesProcessor.call
    end
  end
end