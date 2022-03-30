source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'
gem 'react-rails'

gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

# Cache monay!
gem 'redis'
gem 'redis-rails'

# Product data fetching
gem 'watir-rails'
gem 'webdrivers', '~> 4.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'faker'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end
