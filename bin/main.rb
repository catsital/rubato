# frozen_string_literal: true

begin
  $LOAD_PATH << '../lib'
  require 'scraper'
  require 'optparse'

  # initialize
  class Main
    include Rubato

    def self.scrape(url)
      Rubato::Client.new(index_url: url)
    end

    OptionParser.new do |parser|
      parser.on('-f', '--fetch URL',
                'Fetch images from series or chapter URL') do |fetch_url|
        print scrape(fetch_url).page_parse
      end
      parser.on('-i', '--info URL',
                'Fetch page URL from series or chapter') do |content_url|
        print scrape(content_url).content_parse
      end
    end.parse!
  rescue Interrupt
    raise
  end
rescue Interrupt, StandardError, LoadError => e
  puts e
end
