require 'unirest'
require 'zip'
require 'csv'

def get_password
  url = 'https://challenge.distribusion.com/the_one'
  headers = { 'Accept' => 'application/json' }
  response = Unirest.get url, headers: headers
  data = response.body
  data['pills']['red']['passphrase']
end

def extract_entities(data)
  entity_regex = /\w+\/(?<name>\w+)\.(?<extention>\w+)$/
  Zip::File.open_buffer(data) do |zip|
    zip.each do |entry|
      m = entry.name.match entity_regex
      next unless m
      p m
    end
    # content = routes_entry.get_input_stream.read
    # arr = CSV.parse(content, quote_char: '"', col_sep: ', ', headers: :first_row)
    # p arr[0]
  end
end

password = get_password

all_routes = []

sources = %w(sentinels sniffers loopholes)
sources.each do |source|
  url = 'https://challenge.distribusion.com/the_one/routes'
  parameters = { source: source, passphrase: password }
  response = Unirest.get url, parameters: parameters

  p extract_entities(response.body)
end