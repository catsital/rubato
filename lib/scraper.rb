# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'duktape'
require 'fileutils'
require 'thread/pool'

begin
  module Rubato
    # scraper methods
    class Scraper
      attr_accessor :index_url, :dest_loc

      BASE_URL = 'https://bato.to'

      def initialize(index_url:, dest_loc: '../extract')
        @index_url = index_url
        @dest_loc = dest_loc
      end

      def html_parse(page_url)
        page = URI.parse(page_url).open(
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5)',
          'Accept' => 'text/html',
          'Accept-Encoding' => 'deflate',
          'Referer' => 'http://google.com'
        )
        Nokogiri::HTML(page)
      end

      def title_parse
        if index_url.include? 'series'
          html_parse(index_url).xpath("//h3[@class='item-title']").text.gsub(%r{[?"|:<>*/\\]}, '').strip.to_s
        elsif index_url.include? 'chapter'
          html_parse(index_url).xpath('//title').text.split('-')[0].gsub(%r{[?"|:<>*/\\]}, '').strip.to_s
        end
      end

      def content_list_parse
        html_parse(index_url).xpath("//a[@class='visited chapt']/b").reverse_each.map { |chapter| chapter.text.strip }
      end

      def content_path_parse
        html_parse(index_url).xpath("//a[@class='visited chapt']/@href").reverse_each.map { |loc| BASE_URL + loc.text }
      end

      def content_parse
        series = {}

        if index_url.include? 'series'
          chapter_count = content_list_parse.size
          (0...chapter_count).each do |index|
            chapter_num = content_list_parse[index]
            chapter_url = content_path_parse[index]
            series[chapter_num] = chapter_url
          end
        elsif index_url.include? 'chapter'
          placeholder = html_parse(index_url).xpath('//title').text.split('-')[1].strip
          series[placeholder] = index_url
        end

        series
      rescue Interrupt
        puts 'Exiting...'
      end

      def server_parse(str_batojs, str_server)
        cryptojs = URI.parse('https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.0.0/crypto-js.min.js').read
        duktape = Duktape::Context.new
        batojs = duktape.eval_string(str_batojs)
        decrypt = cryptojs.to_s + "CryptoJS.AES.decrypt(#{str_server}, \"#{batojs}\").toString(CryptoJS.enc.Utf8);"
        duktape.eval_string(decrypt).to_s.gsub('"', '')
      end

      def image_parse(page)
        js = html_parse(page).xpath('//script').text
        str_server = js.split('const server =')[1].split(';')[0]
        str_batojs = js.split('const batojs =')[1].split(';')[0]
        str_images = js.split('const images = ["')[1].split('"];')[0]
        str_images.split('","').map { |image| server_parse(str_batojs, str_server) + image }
      end

      def export(input, output)
        URI.parse(input).open do |image|
          File.open(output, 'wb') do |file|
            file.write(image.read)
          end
          yield until File.exist?(output)
        end
      end

      def page_parse
        pool = Thread.pool(10)
        file_count = 0
        total_count = 0

        content_parse.each do |chapter, path|
          folder_name = "#{dest_loc}/#{title_parse}/#{chapter}"
          FileUtils.mkdir_p(folder_name)
          puts "Creating #{folder_name}"

          image_parse(path).each_with_index do |url, index|
            pool.process do
              file = "#{folder_name}/#{index + 1}.jpeg"
              export(url, file)

              file_count += 1
              puts "Saving #{url} to #{title_parse}/#{chapter}/#{index + 1}.jpeg"

              sleep 2
            end

          rescue Interrupt
            next
          end
          total_count += image_parse(path).size.to_i
        end
        pool.shutdown
        puts "Total number of images saved: #{file_count} / #{total_count}" unless content_parse.empty?
        file_count == total_count
      rescue Interrupt
        puts 'Exiting...'
      end
    end
  end
rescue StandardError, Interrupt => e
  puts e
end
