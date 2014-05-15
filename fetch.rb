#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'ruby-progressbar'

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end


abort "Exemple of usage: $#{$0} http://awesomewebsite.com outputFile.txt" if (ARGV.size != 2)

@url = ARGV[0]
@output = ARGV[1]

# Get a Nokogiri::HTML:Document for the page we’re interested in...
puts "Fetching web page ..."

@doc = Nokogiri::HTML(open(@url,{ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
if @doc.nil?
  abort red('Something went wrong ...')
else
  puts  green('Fetched.')
end

puts "Extracting hyperlinks..."

#Varibles
tempArray = Array.new
count = 1
progress = ProgressBar.create(:starting_at => 0, :total => 200)

@doc.xpath('//a[@href]').each do |link|
  #se for do mesmo dominio colocar no array
  if !link['href'].to_s.include? "http://"
    if !link['href'].to_s.include? "https://"
    tempUrl = @url+"/"+link['href']
    tempArray << tempUrl+"\n"
    end
  end

  if count <= 200
    progress.increment
  end

  count+=1
end

#make strings uniq in the array
tempArray.uniq!

# Write to file
# File.open(@output, 'w') { |file|
#   file.write(tempArray.join(""))
# }

#use webkit2png to take screenshots of the pages
# progress = ProgressBar.create(:starting_at => 0, :total => 200)


tempArray.each do |item|
  puts "Fetching page: "+item
  exec "webkit2png -W 1366 -F "+item
  puts green('Done...')
end
