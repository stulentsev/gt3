require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["admin", "cancan"]
end

redis_conn = proc {
  config = YAML.load_file('config/redis.yml')[Rails.env]
  Redis.new(config)
}

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 2, &redis_conn)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 25, &redis_conn)
end