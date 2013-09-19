#TODO: read redis.yml and initialize redis here

Rails.configuration.redis_wrapper = RedisWrapper.new(nil)