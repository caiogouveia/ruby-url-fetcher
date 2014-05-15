#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'openssl'


abort "Exemple of usage: $#{$0} http://awesomewebsite.com outputFile.txt" if (ARGV.size != 2)

@url = ARGV[0]
@output = ARGV[1]

# Get a Nokogiri::HTML:Document for the page we’re interested in...
puts "Fetching web page ..."
@doc = Nokogiri::HTML(open(@url,{ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
puts "Fetched."

# Do funky things with it using Nokogiri::XML::Node methods...

# puts doc.css('html')
####
# Search for nodes by css
# doc.css('#res #search #ires #rso div li div h3.r a').each do |link|
#   puts link.content
# end
#
# puts doc.xpath('//a[@href]').map {
#   |link| [link.text.strip, link["href"]]
# }

puts "Extracting hiperlinks..."
# hLinksHash = {}
# hLinksHash[count] = tempUrl
tmpHyperlinks = ''
count = 1
@doc.xpath('//a[@href]').each do |link|
  tempUrl = @url+link['href']
  tmpHyperlinks  += tempUrl+"\n"
  count+=1
end
# puts hLinksHash

# Write to file
File.open(@output, 'w') { |file|
  file.write(tmpHyperlinks)
}
