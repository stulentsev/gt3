source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
#gem 'twitter-bootstrap-rails'
#gem 'bootstrap-sass'
gem 'flatstrap-sass'
gem 'font-awesome-rails'

gem 'inherited_resources'

gem 'puma'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'haml'

gem 'simple_form'

gem 'sidekiq', '~> 2.14'
gem 'sidetiq' # recurring jobs
gem 'sinatra'

gem 'exceptional'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


# Databases
gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongoid-paranoia', github: 'simi/mongoid-paranoia'

gem 'redis'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'rack-cors', :require => 'rack/cors'

group :development do
  gem 'pry'
  #gem 'pry-debugger'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'zeus'
  gem 'rspec-rails'
end

group :test do
  gem 'fuubar_velocity'
  gem 'guard-rspec'
  gem 'mongoid-rspec'
  gem 'simplecov', :require => false
end