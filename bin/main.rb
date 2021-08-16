# frozen_string_literal: true

begin
  $LOAD_PATH << '../lib'
  require 'scraper'
  require 'optparse'

  # initialize
  class Main
    include Rubato

    def self.scrape(url)
      Rubato::Scraper.new(index_url: url)
    end

    OptionParser.new do |parser|
      parser.on('-f', '--fetch URL',
                'Fetch image(s) from a series or chapter link') do |fetch_url|
        print scrape(fetch_url).page_parse
      end
      parser.on('-c', '--chapters URL',
                'Fetch page link(s) from a series or chapter page') do |content_url|
        print scrape(content_url).content_parse
      end
      parser.on('-p', '--pages URL',
                'Fetch image link(s) from an individual chapter page') do |image_url|
        print scrape(image_url).image_parse(image_url)
      end
    end.parse!
  rescue Interrupt
    raise
  end
rescue Interrupt, StandardError, LoadError => e
  puts e
end
