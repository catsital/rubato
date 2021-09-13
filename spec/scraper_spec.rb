# frozen_string_literal: true

require 'rspec'
require_relative '../lib/scraper'

describe Rubato do
  subject(:scraper) { Rubato::Scraper.new(index_url: 'https://bato.to/series/81565') }
  describe '#content_parse' do
    it 'returns chapter page links parsed from a series page' do
      expect(scraper.content_parse).to eql(
        'Chapter 1' => 'https://bato.to/chapter/1561269',
        'Chapter 2' => 'https://bato.to/chapter/1561270',
        'Chapter 3' => 'https://bato.to/chapter/1561271',
        'Chapter 4' => 'https://bato.to/chapter/1561272',
        'Chapter 5' => 'https://bato.to/chapter/1561273',
        'Chapter 6' => 'https://bato.to/chapter/1561274',
        'Chapter 7' => 'https://bato.to/chapter/1561276',
        'Chapter 8' => 'https://bato.to/chapter/1561277',
        'Chapter 9' => 'https://bato.to/chapter/1561278',
        'Chapter 10' => 'https://bato.to/chapter/1561279',
        'Chapter 11' => 'https://bato.to/chapter/1561280',
        'Chapter 12' => 'https://bato.to/chapter/1561281'
      )
    end
  end

  describe '#page_parse' do
    it 'fetch all images to the local drive' do
      expect(scraper.page_parse).to eql(356)
    end
  end
end
