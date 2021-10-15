# frozen_string_literal: true

begin
  $LOAD_PATH << '../lib'
  require 'scraper'
  require 'optparse'
  require 'pp'

  # initialize
  class Main
    include Rubato

    scrape = Rubato::Scraper.new
    options = {
      :output => '../extract'
    }

    OptionParser.new do |parser|
      parser.program_name = "Rubato"
      parser.version = "0.1.0"
      parser.banner = "Usage: main [options]"

      parser.on('-f', '--fetch URL',
                'Download images from a series or chapter page') do |url|
        if url.include? 'chapter'
          print scrape.page_parse(url, dest_loc: options[:output])

        elsif url.include? 'series'
          page = scrape.html_parse(url)
          content = scrape.series_parse(page)
          content.each do |chapter, path|
            scrape.page_parse(chapter, dest_loc: options[:output])
          end
        else
          puts "Cannot parse this page."
        end
      end

      parser.on('-c', '--chapters URL',
                'Get page links from a series page') do |url|
        if url.include? 'series'
          pp scrape.series_parse(scrape.html_parse(url))
        else
          puts "Cannot parse this page."
        end
      end

      parser.on('-p', '--pages URL',
                'Get image links from an individual chapter page') do |url|
        if url.include? 'chapter'
          pp scrape.image_parse(scrape.html_parse(url))
        else
          puts "Cannot parse this page."
        end
      end

      parser.on('-o', '--output DIR',
                'Set output directory') do |path|
                  options[:output] = path
      end

      parser.on_tail("-h", "--help", "Show this message") do
        puts parser
        exit
      end

      parser.on_tail("-v", "--version", "Show version") do
        puts "#{parser.program_name} #{parser.version}"
        exit
      end
    end.parse!
  rescue Interrupt
    raise
  end
rescue Interrupt, StandardError, LoadError => e
  puts e
end
