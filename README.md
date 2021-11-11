# Rubato
Rubato is a simple image scraper for [Bato](https://bato.to).

## Getting Started

### Prerequisites
* Ruby 2.6.5+

### Setup
* First, you should get a copy of this project in your local machine by either downloading the zip file or cloning the repository. `git clone https://github.com/catsital/rubato.git`
* `cd` into `rubato` directory.
* Run `bundle install` to install dependencies.

### Usage
Using the command-line utility, `cd` into `bin` and simply run:

```bash
$ ruby main.rb -f {series_url|chapter_url}
```

Images are stored under the default folder `extract`, in a fixed directory tree structure like below.

```
rubato
└───extract
    └───<series-name>
        └───<chapter-name>
            ├───1.jpeg
            ├───2.jpeg
            └───...
```

You can also scrape by using `scraper.rb` in a Ruby script:

```ruby
require 'lib/scraper'
rubato = Rubato::Scraper.new
rubato.page_parse('https://bato.to/series/77397')
```

## Options

<code>-f <i>url</i></code>, <code>--fetch <i>url</i></code>
* Downloads the images parsed from a page

<code>-c <i>url</i></code>, <code>--chapters <i>url</i></code>
* Returns a hash of links parsed from a page

<code>-p <i>url</i></code>, <code>--pages <i>url</i></code>
* Returns an array of image links parsed from a page

<code>-o <i>path</i></code>, <code>--output <i>path</i></code>
* Output directory

<code>-t <i>filetype</i></code>, <code>--type <i>filetype</i></code>
* Output format

## License

See [LICENSE](https://github.com/catsital/rubato/blob/main/LICENSE) for details.

## Disclaimer

The developer of this script does not have any affiliation with Bato.
