# Scouter

Welcome to `scouter`! This rails application fetches a product from amazon, given the ASIN and saves/displays it for your viewing convenience!

## Development

1. `scouter` uses postgresql for a data store and redis for caching. You'll need to ensure you have both running, if you don't already.

Check with:

```
brew services list
```

Install with:

```
brew install postgresql
brew install redis
```

If they aren't running just use: `brew services start <resource>`

2. Make sure you have ruby 2.6.4 installed. If you are using rvm, you can check by:

```
rvm list
rvm use 2.6.4
```

otherwise, to install:

```
rvm install ruby-2.6.4 && rvm use 2.6.4
```

3. Database!! Gems!!!! and starting it up

Run setup in `bin/setup` for creating a new database and bundling gems

4. Now navigate away to `localhost:3000`!

```
rails s
```

## Specs

Run tests with `bundle exec rspec`

## Usage

Navigate to the `Products` page using the link in the top bar. Enter the desired ASIN to be fetched from Amazon and press the `Retrieve Product Information!` button! You can also check the use proxy checkbox to enable fetching with proxies, but this will slow down the fetch.

## Implementation Details

- Abstracted ASIN to `ext_id` so any platform can be included
- Using `watir` and `webdrivers` for fetching page elements, only chrome and firefox support headless browsing
- Proxies can be enabled when fetching a product, but it will take longer to fetch
- Fetching the product will attempt to try 3 times with a default 30 second timeout
