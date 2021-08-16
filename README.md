# Rubato
Rubato is a simple image scraper for [Bato](https://bato.to).

![rubato](https://user-images.githubusercontent.com/18095632/127259012-0456d1ee-f6d5-4611-8d05-96a164c2d200.gif)

## Getting Started

### Prerequisites
* Ruby 2.6.5+

### Setup
* First, you should get a copy of this project in your local machine by either downloading the zip file or cloning the repository. `git clone https://github.com/catsital/rubato.git`
* `cd` into `rubato` directory.
* Run `bundle install` to install dependencies.

### Usage
Using command line, `cd` into `bin` and simply use:

```
ruby main.rb -f {series_url|chapter_url}
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

You can also scrape by using `scraper.rb` and writing:

```ruby
require 'lib/scraper'
rubato = Rubato::Scraper.new(index_url: 'https://bato.to/series/77397')
rubato.page_parse()
```

## Options

<code>-f <i>url</i></code>, <code>--fetch <i>url</i></code>
* Downloads the images parsed from a page

<code>-c <i>url</i></code>, <code>--chapters <i>url</i></code>
* Returns a hash of links parsed from a page

<code>-p <i>url</i></code>, <code>--pages <i>url</i></code>
* Returns an array of image links parsed from a page


## License

See [LICENSE](https://github.com/catsital/rubato/blob/main/LICENSE) for details.

## Disclaimer

The developer of this script does not have any affiliation with Bato.
