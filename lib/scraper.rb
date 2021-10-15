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
      BASE_URL = 'https://bato.to'

      def html_parse(page_url)
        page = URI.parse(page_url).open(
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5)',
          'Accept' => 'text/html',
          'Accept-Encoding' => 'deflate',
          'Referer' => 'http://google.com'
        )
        Nokogiri::HTML(page)
      end

      def title_parse(page)
        series = page.xpath('//title').text.split('-')[0].gsub(%r{[?"|:<>*/\\]}, '').strip.to_s
        chapter = page.xpath('//title').text.split('-')[1].strip
        title = [series, chapter]
      end

      def series_parse(page)
        series = {}
        content_list = page.xpath("//a[@class='visited chapt']/b").reverse_each.map { |chapter| chapter.text.strip }
        content_path = page.xpath("//a[@class='visited chapt']/@href").reverse_each.map { |url| BASE_URL + url.text }

        chapter_count = content_list.size
        (0...chapter_count).each do |index|
          chapter_num = content_list[index]
          chapter_url = content_path[index]
          series[chapter_num] = chapter_url
        end

        series
      rescue Interrupt
        puts 'Exiting...'
      end

      def image_parse(page)
        js = page.xpath('//script').text
        str_server = js.split('const server =')[1].split(';')[0]
        str_batojs = js.split('const batojs =')[1].split(';')[0]
        str_images = js.split('const images = ["')[1].split('"];')[0]
        str_images.split('","').map { |image| server_parse(str_batojs, str_server) + image }
      end

      def server_parse(str_batojs, str_server)
        cryptojs = URI.parse('https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.0.0/crypto-js.min.js').read
        duktape = Duktape::Context.new
        batojs = duktape.eval_string(str_batojs)
        decrypt = cryptojs.to_s + "CryptoJS.AES.decrypt(#{str_server}, \"#{batojs}\").toString(CryptoJS.enc.Utf8);"
        duktape.eval_string(decrypt).to_s.gsub('"', '')
      end

      def export(input, output)
        URI.parse(input).open(
            'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5)',
            'Referer' => BASE_URL
        ) do |image|
          File.open(output, 'wb') do |file|
            file.write(image.read)
          end
          yield until File.exist?(output)
        end
      end

      def display_progress_bar(file_count, total_count, scale: 0.55)
        max_width = (100 * scale).to_i
        filled = (max_width * file_count / total_count.to_f).round.to_i
        remaining = max_width - filled.to_i
        progress_bar = "█" * filled.to_i + " " * remaining
        percent = (100.0 * file_count / total_count.to_f).round(1)
        text = "   |#{progress_bar}| #{percent}% (#{file_count}/#{total_count})\r"
        print text
      end

      def page_parse(url, dest_loc: '../extract')
        pool = Thread.pool(3)
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        file_count = 0

        page = html_parse(url)
        title = title_parse(page)

        folder_name = "#{dest_loc}/#{title[0]}/#{title[1]}"

        FileUtils.mkdir_p(folder_name)
        puts "\nTitle: #{title[0]}\nChapter: #{title[1]}"

        images = image_parse(page)

        images.each_with_index do |url, index|
          pool.process do
            file = "#{folder_name}/#{index + 1}.jpeg"
            export(url, file) unless File.exist? file
            file_count += 1
            display_progress_bar(file_count, images.size.to_i)
            sleep 2
          end
        rescue Interrupt
          next
        end

        pool.shutdown
        elapsed_time = (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time).round(1)
        puts "\nElapsed time: #{elapsed_time}s\n"
      rescue Interrupt
        puts 'Exiting...'
      end
    end
  end
rescue StandardError, Interrupt => e
  puts e
end
