require 'unirest'

# get pills

url = 'https://challenge.distribusion.com/the_one'
headers = { 'Accept' => 'application/json' }
response = Unirest.get url, headers: headers
data = response.body

password = data['pills']['red']['passphrase']

p password