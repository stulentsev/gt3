# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'sidekiq/testing'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include Mongoid::Matchers
  config.include FactoryGirl::Syntax::Methods # for create(:app) instead of FactoryGirl.create(:app)

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.mock_with :rspec do |configuration|
    configuration.syntax = [:expect, :should]
  end

  config.before(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
    Rails.configuration.redis_wrapper.redis.flushdb

    Sidekiq::Testing.fake!
    Sidekiq::Worker.clear_all
  end

  config.order = "random"
end
