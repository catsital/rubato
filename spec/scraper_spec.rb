# frozen_string_literal: true

require 'rspec'
require 'pathname'
require_relative '../lib/scraper'

describe Rubato do
  subject(:scraper) { Rubato::Scraper.new }
  describe '#series_parse' do
    it 'returns chapter page links parsed from a series page' do
      expect(
        scraper.series_parse(
          scraper.html_parse('https://bato.to/series/81565')
        )
      ).to eql(
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

  describe '#image_parse' do
    it 'returns the number of pages in a chapter' do
      expect(
        scraper.image_parse(
          scraper.html_parse('https://bato.to/chapter/1561280')
        ).size
      ).to eql(26)
    end
  end

  describe '#page_parse' do
    it 'fetch all images to the local drive' do
      scraper.page_parse('https://bato.to/chapter/1561280')
      expect(
        Pathname.new("../extract/Rascal Does Not Dream of Petite Devil Kohai/Chapter 11")
      ).to exist
    end
  end
end
