source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

gem 'inherited_resources'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'haml'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


# Databases
gem 'mongoid', github: 'mongoid/mongoid'
gem 'redis'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

group :development do
  gem 'pry'
  gem 'capistrano'
  gem 'capistrano-ext'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'zeus'
end

group :test do
  gem 'fuubar'
  gem 'guard-rspec'
  gem 'mongoid-rspec'
  gem 'rspec-rails'
end