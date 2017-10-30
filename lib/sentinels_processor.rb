require 'unirest'
require 'service'

module DistributionChallenge
  class SentinelsProcessor
    include Service

    URL = 'https://challenge.distribusion.com/the_one/routes'
    SOURCE = 'sentinels'

    attr_reader :password
    attr_reader :data
    attr_reader :data_to_send
    attr_reader :entities

    def initialize(password)
      @password = password
      @entities = {}
    end

    def call
      load_data
      extract_entities
      construct_data_to_send
      responses = send_data
      responses
    end

    private

    def load_data
      parameters = { source: SOURCE, passphrase: password }
      response = Unirest.get URL, parameters: parameters
      @data = response.body
    end

    def send_data
      base_parameters = { source: SOURCE, passphrase: password }
      data_to_send.map do |parameters|
        response = Unirest.post URL, parameters: parameters.merge(base_parameters)
        response.body
      end
    end

    def extract_entities
      entity_regex = /\w+\/(?<name>\w+)\.(?<extention>\w+)$/

      Zip::File.open_buffer(data) do |zip|
        zip.each do |entry|
          m = entry.name.match entity_regex
          next unless m
          entity_name = m[:name]
          entities[entity_name] = parse_entities(entry, m[:extention])
        end
      end
    end

    def parse_entities(entry, extention)
      case extention
      when 'csv'
        parse_csv_entities(entry)
      when 'json'
        parse_json_entities(entry)
      end
    end

    def parse_csv_entities(entry)
      content = entry.get_input_stream.read
      CSV.parse(content, quote_char: '"', col_sep: ', ', headers: :first_row).map(&:to_hash)
    end

    def parse_json_entities(entry)
      content = entry.get_input_stream.read
      h = JSON.parse(content)
      main_key = h.keys.first
      h[main_key]
    end

    def construct_data_to_send
      @data_to_send = @entities['routes'].map do |route|
        {
          start_node: route['node'],
          end_node: route['node'],
          start_time: route['time'],
          end_time: route['time']
        }
      end
    end
  end
end
