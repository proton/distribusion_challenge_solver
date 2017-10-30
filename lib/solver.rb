lib_dir = File.expand_path(File.dirname(__FILE__) + '/../lib')
$:.unshift(lib_dir) unless $:.include?(lib_dir)

require 'unirest'
require 'zip'
require 'csv'

require 'password_loader'

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
      all_routes = []

      SOURCES.each do |source|
        url = 'https://challenge.distribusion.com/the_one/routes'
        parameters = { source: source, passphrase: password }
        response = Unirest.get url, parameters: parameters

        p extract_entities(response.body)
      end
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