config = YAML.load_file('config/redis.yml')[Rails.env]
redis = Redis.new(config)

Rails.configuration.redis_wrapper = RedisWrapper.new(redis)