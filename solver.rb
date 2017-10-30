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

password = get_password

all_routes = []

sources = %w(sentinels sniffers loopholes)
sources.each do |source|
  url = 'https://challenge.distribusion.com/the_one/routes'
  parameters = { source: source, passphrase: password }
  response = Unirest.get url, parameters: parameters

  entity_regex = /^#{source}.*\/\w+.*$/
  Zip::File.open_buffer(response.body) do |zip|
    entries = zip.select { |entry| entry.name =~ entity_regex }
    puts entries
    # routes_entry = zip.detect { |entry| entry.name =~ /^#{source}.*\/routes.*\.csv$/ }
    # content = routes_entry.get_input_stream.read
    # arr = CSV.parse(content, quote_char: '"', col_sep: ', ', headers: :first_row)
    # p arr[0]
  end
end

# Zip::File.open_buffer(response.body) do |zip|
#   routes_entry = zip.detect { |entry| entry.name =~ /^#{source}.*\/routes.*\.csv$/ }
#   content = routes_entry.get_input_stream.read
#   arr = CSV.parse(content, quote_char: '"', col_sep: ', ', headers: :first_row)
#   p arr[0]
# end
#
# # get sniffers
#
# source = 'sniffers'
# parameters = { source: source, passphrase: password }
# response = Unirest.get routes_url, parameters: parameters
#
# Zip::File.open_buffer(response.body) do |zip|
#   puts zip.to_a
#   # routes_entry = zip.detect { |entry| entry.name =~ /^#{source}.*\/routes.*\.csv$/ }
#   # content = routes_entry.get_input_stream.read
#   # arr = CSV.parse(content, quote_char: '"', col_sep: ', ', headers: :first_row)
#   # p arr[0]
# end