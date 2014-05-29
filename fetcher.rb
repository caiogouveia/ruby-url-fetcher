require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'ruby-progressbar'
require 'open3'


class Fetcher

  attr_accessor :domain,:outputTextFile,:outputDirectory,:screenShotSleepTime,:htmlDocument
  #
  #
  #
  def initialize
    # abort "Exemple of usage: $#{$0} http://awesomewebsite.com outputFile.txt" if (ARGV.size != 2)
    # makeScreenShot(grabUrlsFromDomain(@domain))
  end

  def setup(domain,outputFile)
    @domain = domain#ARGV[0]
    @outputTextFile = outputFile#ARGV[1]
    @screenShotSleepTime = 5
    @outputDirectory = @domain.gsub('http://', '')
  end

  def initOutput
    puts "Domain: "+@domain
    puts "outputTextFile: "+@outputTextFile
    puts "outputDirectory: "+@outputDirectory
  end

  #
  # Use Nokogiri to extract urls from hyperlinks
  #
  def grabUrlsFromDomain(domain)
    @htmlDocument = Nokogiri::HTML(open(domain,{ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
    if @htmlDocument.nil?
      abort red('Something went wrong ...')
    else
      puts  green('Fetched.')
    end

    #Varibles
    tempArray = Array.new
    count = 1
    progress = ProgressBar.create(:starting_at => 0, :total => 200)

    @htmlDocument.xpath('//a[@href]').each do |link|
      #se for do mesmo dominio colocar no array
      if !link['href'].to_s.include? "http://"
        if !link['href'].to_s.include? "https://"
          tempUrl = domain+"/"+link['href']
          tempArray << tempUrl+"\n"
        end
      end

      if count <= 200
        progress.increment
      end

      count+=1
    end

    #make they uniq then return
    return tempArray.uniq!

  end

  #
  # use webkit2png to take screenshots of the pages
  # progress = ProgressBar.create(:starting_at => 0, :total => 200)
  #
  def makeScreenShot(urlArray)
    urlArray.each do |item|
      puts "Item: "+item
      cmd = "webkit2png -W 1366 -D "+@outputDirectory+" -F "+item

      Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
        puts "stdout is:" + stdout.read
        puts "stderr is:" + stderr.read
      end

      puts green('Done...')
      sleep(@screenShotSleepTime)
    end
  end

  #
  # Make a txt file with the urls
  #
  def writeOutput(outputFile,array)
    Write to file
    File.open(outputFile, 'w') { |file|
      file.write(array.join(""))
    }
  end


  ## Utils
  def colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def red(text); colorize(text, 31); end
  def green(text); colorize(text, 32); end

end

class Bootstrap
  def initialize
    abort "Usage: $#{$0} http://awesomewebsite.com outputFile.txt" if (ARGV.size != 2)
    fetcher = Fetcher.new()
    fetcher.setup(ARGV[0],ARGV[1])
    fetcher.initOutput
    fetcher.makeScreenShot(fetcher.grabUrlsFromDomain(fetcher.domain))
  end
end

f = Bootstrap.new()
