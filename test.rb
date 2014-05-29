require "./fetcher"
require "minitest/autorun"
# require "test/unit"

class TestFetcher < MiniTest::Unit::TestCase

  def setup
    @fetcher = Fetcher.new()
  end

  def teardown
  end

  # def test_ArgNumberFail
  #   assert_equal(
  #   "Usage: $fetcher.rb http://awesomewebsite.com outputFile.txt",
  #   @fetcher.setup
  #   )
  # end

  def test_ArgNumberFail2
    assert(@fetcher.setup("http://awesomewebsite.com",""))
  end

  def test_A
    assert(@fetcher.setup("http://awesomewebsite.com","output.txt"))
  end

  def test_initOutput
    @fetcher.setup("http://awesomewebsite.com","output.txt")
    assert_equal(
    "Domain: awesomewebsite.com
    outputTextFile: output.txt
    outputDirectory: awesomewebsite.com",
    @fetcher.initOutput
    )
  end

end
