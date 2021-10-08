# frozen_string_literal: true

begin
  $LOAD_PATH << '../lib'
  require 'scraper'
  require 'optparse'

  # initialize
  class Main
    include Rubato

    scrape = Rubato::Scraper.new

    OptionParser.new do |parser|
      parser.on('-f', '--fetch URL',
                'Fetch image(s) from a series or chapter page') do |fetch_url|
        if fetch_url.include? 'chapter'
          print scrape.page_parse(fetch_url)
        end

        if fetch_url.include? 'series'
          page = scrape.html_parse(fetch_url)
          content = scrape.series_parse(page)
          content.each do |chapter, path|
            scrape.page_parse(path)
          end
        end
      end
      parser.on('-c', '--chapters URL',
                'Fetch page link(s) from a series page') do |content_url|
        print scrape.series_parse(scrape.html_parse(content_url))
      end
      parser.on('-p', '--pages URL',
                'Fetch image link(s) from an individual chapter page') do |image_url|
        print scrape.image_parse(scrape.html_parse(image_url))
      end
    end.parse!
  rescue Interrupt
    raise
  end
rescue Interrupt, StandardError, LoadError => e
  puts e
end
