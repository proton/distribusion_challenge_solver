require 'unirest'
require 'zip'
require 'csv'

# get pills

initial_url = 'https://challenge.distribusion.com/the_one'
headers = { 'Accept' => 'application/json' }
response = Unirest.get initial_url, headers: headers
data = response.body
password = data['pills']['red']['passphrase']

p password

# get sentinels

routes_url = 'https://challenge.distribusion.com/the_one/routes'

source = 'sentinels'
parameters = { source: source, passphrase: password }
response = Unirest.get routes_url, parameters: parameters

Zip::File.open_buffer(response.body) do |zip|
  routes_entry = zip.detect { |entry| entry.name =~ /^#{source}.*\/routes.*\.csv$/ }
  content = routes_entry.get_input_stream.read
  arr = CSV.parse(content, quote_char: '"', col_sep: ', ', headers: :first_row)
  p arr[0]
end