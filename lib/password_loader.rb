require 'unirest'
require 'service'

module DistributionChallenge
  class PasswordLoader
    include Service

    URL = 'https://challenge.distribusion.com/the_one'

    attr_reader :data

    def call
      load_data
      password
    end

    private

    def password
      data['pills']['red']['passphrase']
    end

    def load_data
      headers = { 'Accept' => 'application/json' }
      response = Unirest.get URL, headers: headers
      @data = response.body
    end
  end
end