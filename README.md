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
To start scraping, `cd` into `bin` and simply use:
```
ruby main.rb -f {series_url|chapter_url}
```
Images are stored under the default folder `./extract`, in a fixed directory tree structure like below.
```
rubato
└───extract
    └───<series-name>
        └───<chapter-name>
            ├───0.jpeg
            ├───1.jpeg
            └───...
```

## License

This project is [MIT](https://opensource.org/licenses/MIT) licensed.

## Disclaimer

The developer of this script does not have any affiliation with Bato.
