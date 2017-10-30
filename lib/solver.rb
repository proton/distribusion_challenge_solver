require 'unirest'
require 'zip'
require 'csv'

module DistributionChallenge
  class Solver
    include ::Service

    def call
      password = get_password

      all_routes = []

      sources = %w(sentinels sniffers loopholes)
      sources.each do |source|
        url = 'https://challenge.distribusion.com/the_one/routes'
        parameters = { source: source, passphrase: password }
        response = Unirest.get url, parameters: parameters

        p extract_entities(response.body)
      end
    end

    private

    def get_password
      url = 'https://challenge.distribusion.com/the_one'
      headers = { 'Accept' => 'application/json' }
      response = Unirest.get url, headers: headers
      data = response.body
      data['pills']['red']['passphrase']
    end

    def parse_csv_entities(entry)
      content = entry.get_input_stream.read
      CSV.parse(content, quote_char: '"', col_sep: ', ', headers: :first_row).map(&:to_hash)
    end

    def singularize(name)
      name.sub(/s$/, '')
    end

    def parse_json_entities(entry)
      content = entry.get_input_stream.read
      h = JSON.parse(content)
      main_key = h.keys.first
      h[main_key]
    end

    def extract_entities(data)
      entity_regex = /\w+\/(?<name>\w+)\.(?<extention>\w+)$/
      result = {}
      # loading
      Zip::File.open_buffer(data) do |zip|
        zip.each do |entry|
          m = entry.name.match entity_regex
          next unless m
          entity_name = m[:name]
          result[entity_name] = case m[:extention]
          when 'csv'
            parse_csv_entities(entry)
          when 'json'
            parse_json_entities(entry)
          end
        end
      end
      # indexing
      result.each do |entity_name, entities|
        id_field = singularize(entity_name) + '_id'
        h = entities.map do |entity|
          id = entity.delete id_field
          id ||= entity.delete 'id'
          [id, entity]
        end.to_h
        result[entity_name] = h
      end
      result
    end
  end
end